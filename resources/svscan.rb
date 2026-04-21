# frozen_string_literal: true

provides :daemontools_svscan
unified_mode true
default_action :enable

include Daemontools::Helpers

use '_partial/_service_directory'

property :instance_name, String, name_property: true
property :install_style, Symbol, equal_to: %i(source package aur), required: true
property :bin_dir, String, default: lazy { default_runtime_bin_dir }
property :service_name, String, default: lazy { default_svscan_service_name(install_style) }
property :source_directory, String, default: lazy { default_source_directory }
property :csh_package_name, String, default: 'csh'

action_class do
  include Daemontools::Helpers

  def source_install?
    new_resource.install_style == :source
  end

  def systemd_unit_content
    {
      Unit: {
        Description: 'Daemontools service supervision',
      },
      Service: {
        ExecStart: "#{new_resource.bin_dir}/svscanboot #{new_resource.service_dir}",
        Restart: 'always',
      },
      Install: {
        WantedBy: 'multi-user.target',
      },
    }
  end
end

action :enable do
  directory new_resource.service_dir do
    recursive true
    mode '0755'
  end

  if source_install?
    if svscan_uses_systemd?
      systemd_unit "#{new_resource.service_name}.service" do
        content systemd_unit_content
        action %i(create enable start)
        triggers_reload true
      end
    else
      package new_resource.csh_package_name do
        action :install
      end

      execute "register #{new_resource.service_name} in rc.local" do
        command "(cd #{new_resource.source_directory}; package/run.rclocal)"
        not_if 'grep svscanboot /etc/rc.local'
      end
    end
  else
    service new_resource.service_name do
      action %i(enable start)
    end
  end
end

action :disable do
  if source_install? && svscan_uses_systemd?
    systemd_unit "#{new_resource.service_name}.service" do
      action %i(stop disable)
    end
  elsif !source_install?
    service new_resource.service_name do
      action %i(stop disable)
    end
  end
end
