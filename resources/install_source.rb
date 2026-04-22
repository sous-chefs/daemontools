# frozen_string_literal: true

provides :daemontools_install_source
unified_mode true
default_action :create

include Daemontools::Helpers

use '_partial/_service_directory'

property :instance_name, String, name_property: true
property :bin_dir, String, default: lazy { default_source_bin_dir }
property :source_url, String, default: 'http://cr.yp.to/daemontools/daemontools-0.76.tar.gz'
property :source_checksum, String, default: 'a55535012b2be7a52dcd9eccabb9a198b13be50d0384143bd3b32b8710df4c1f'
property :build_packages, [String, Array],
         coerce: proc { |value| Array(value) },
         default: lazy { default_source_build_packages }
property :source_archive_path, String, default: lazy { default_source_archive_path }
property :source_directory, String, default: lazy { default_source_directory }

action_class do
  include Daemontools::Helpers
end

action :create do
  apt_update 'daemontools source build metadata' do
    action :periodic
  end if platform_family?('debian')

  new_resource.build_packages.each do |build_package|
    package build_package do
      action :install
    end
  end

  directory new_resource.bin_dir do
    recursive true
    mode '0755'
  end

  remote_file new_resource.source_archive_path do
    source new_resource.source_url
    checksum new_resource.source_checksum
    owner 'root'
    group 'root'
    mode '0644'
  end

  directory new_resource.source_directory do
    recursive true
    mode '0755'
  end

  execute "extract #{new_resource.instance_name} source" do
    command "tar xzf #{new_resource.source_archive_path} -C #{new_resource.source_directory} --strip-components=2"
    not_if { ::File.exist?(::File.join(new_resource.source_directory, 'package', 'compile')) }
  end

  execute "compile #{new_resource.instance_name} source" do
    cwd new_resource.source_directory
    creates ::File.join(new_resource.bin_dir, 'svc')
    command <<~EOH
      perl -0pi -e 's/extern int errno;/#include <errno.h>/' src/error.h
      perl -0pi -e 's/#include "pathexec.h"/#include "pathexec.h"\\n#include <unistd.h>/' src/pathexec_run.c
      perl -0pi -e 's/execve\\(([^,]+),argv,envp\\)/execve($1,(char * const *) argv,(char * const *) envp)/g' src/pathexec_run.c
      perl -0pi -e 's/#include <unistd.h>/#include <unistd.h>\\n#include <grp.h>/' src/chkshsgr.c
      perl -0pi -e 's/short x\\[4\\];/gid_t x[4];/' src/chkshsgr.c
      perl -0pi -e 's/#include "prot.h"/#include "prot.h"\\n#include <grp.h>\\n#include <unistd.h>/' src/prot.c
      perl -0pi -e 's/setgroups\\(1,&gid\\)/setgroups(1,(gid_t *) &gid)/' src/prot.c
      perl -0pi -e 's/setgid\\(gid\\)/setgid((gid_t) gid)/' src/prot.c
      perl -0pi -e 's/setuid\\(uid\\)/setuid((uid_t) uid)/' src/prot.c
      perl -0pi -e 's/#include "seek.h"/#include "seek.h"\\n#include <unistd.h>/' src/seek_set.c
      perl -0pi -e 's/#include "sig.h"/#include "sig.h"\\n#include <unistd.h>/' src/sig_pause.c
      perl -0pi -e 's/sigpause\\(0\\);/pause();/' src/sig_pause.c
      perl -0pi -e 's/#include "str.h"/#include "str.h"\\n#include <unistd.h>/' src/matchtest.c
      perl -0pi -e 's/#include <unistd.h>/#include <unistd.h>\\n#include <stdio.h>/' src/multilog.c
      perl -0pi -e 's/execve\\("\\/bin\\/sh",args,environ\\)/execve("\\/bin\\/sh",(char * const *) args,environ)/' src/multilog.c
      perl -0pi -e 's/#include <unistd.h>/#include <unistd.h>\\n#include <stdio.h>/' src/supervise.c
      perl -0pi -e 's/execve\\(\\*run,run,environ\\)/execve(*run,(char * const *) run,environ)/' src/supervise.c
      perl -0pi -e 's/pathexec_run\\(([^,]+),([^,]+),environ\\)/pathexec_run($1,$2,(const char * const *) environ)/g' src/svscan.c
      perl -0pi -e 's/\\n\\z/ -Wno-error=implicit-function-declaration\\n/' src/conf-cc
      package/compile
      install -m 0555 command/* #{new_resource.bin_dir}
    EOH
  end

  template ::File.join(new_resource.bin_dir, 'svscanboot') do
    cookbook 'daemontools'
    source 'svscanboot.erb'
    owner 'root'
    group 'root'
    mode '0555'
    variables(
      bin_dir: new_resource.bin_dir,
      service_dir: new_resource.service_dir
    )
  end
end
