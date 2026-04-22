# frozen_string_literal: true

provides :daemontools_install_aur
unified_mode true
default_action :create

include Daemontools::Helpers

use '_partial/_service_directory'

property :instance_name, String, name_property: true
property :package_name, String, default: 'daemontools'
property :patches, [String, Array],
         coerce: proc { |value| Array(value) },
         default: ['daemontools-0.76.svscanboot-path-fix.patch']
property :build_packages, [String, Array],
         coerce: proc { |value| Array(value) },
         default: ['fakeroot']

action :create do
  raise "daemontools_install_aur only supports Arch Linux, not #{node['platform']}" unless platform?('arch')

  if new_resource.service_dir != '/etc/service'
    raise "service_dir(#{new_resource.service_dir}) must be /etc/service for aur installation"
  end

  include_recipe 'pacman::default'

  new_resource.build_packages.each do |build_package|
    package build_package do
      action :install
    end
  end

  pacman_aur new_resource.package_name do
    patches new_resource.patches
    pkgbuild_src true
    action %i(build install)
  end
end
