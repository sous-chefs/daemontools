#
# Cookbook:: daemontools
# Recipe:: source
#
# Copyright:: 2010-2012, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

remote_file "#{Chef::Config[:file_cache_path]}/daemontools.tar.gz" do
  source node['daemontools']['source_url']
  checksum node['daemontools']['source_checksum']
  owner 'root'
end

directory '/tmp/daemontools' do
  recursive true
end

bash 'install_daemontools' do
  user 'root'
  cwd Chef::Config[:file_cache_path]
  not_if { ::File.exist?("#{node['daemontools']['bin_dir']}/svc") }
  code <<~EOCODE
    (tar zxvf daemontools.tar.gz -C /tmp/daemontools --strip-components 2)
    (cd /tmp/daemontools; perl -pi -e 's/extern int errno;/\#include <errno.h>/' src/error.h)
    (cd /tmp/daemontools; package/compile)
    (cd /tmp/daemontools; mv command/* #{node['daemontools']['bin_dir']})
  EOCODE
end

# Original svscanboot in tarball expects bindir=/command, service_dir=/service
template "#{node['daemontools']['bin_dir']}/svscanboot" do
  source 'svscanboot.erb'
  owner 'root'
  group 'root'
  mode '0o555'
  variables(
    bin_dir: node['daemontools']['bin_dir'],
    service_dir: node['daemontools']['service_dir']
  )
end
