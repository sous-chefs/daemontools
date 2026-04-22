# frozen_string_literal: true

provides :daemontools_install_package
unified_mode true
default_action :create

include Daemontools::Helpers

use '_partial/_service_directory'

property :instance_name, String, name_property: true
property :package_name, String, default: lazy { default_package_name }

action_class do
  include Daemontools::Helpers
end

action :create do
  apt_update 'daemontools package metadata' do
    action :periodic
  end if platform_family?('debian')

  if platform?('gentoo') && new_resource.service_dir != '/service'
    raise "service_dir(#{new_resource.service_dir}) must be /service for gentoo package installation"
  end

  package new_resource.package_name do
    action :install
  end
end
