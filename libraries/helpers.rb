# frozen_string_literal: true

module Daemontools
  module Helpers
    def default_package_name
      case node['platform']
      when 'debian', 'ubuntu'
        'daemontools-run'
      when 'gentoo'
        'sys-process/daemontools'
      else
        'daemontools'
      end
    end

    def default_runtime_bin_dir
      case node['platform']
      when 'debian', 'ubuntu', 'gentoo'
        '/usr/bin'
      when 'arch'
        '/usr/sbin'
      else
        '/usr/local/bin'
      end
    end

    def default_service_dir
      node['platform'] == 'gentoo' ? '/service' : '/etc/service'
    end

    def default_source_bin_dir
      '/usr/local/bin'
    end

    def default_source_build_packages
      if platform_family?('debian')
        %w(build-essential perl)
      else
        %w(gcc make perl)
      end
    end

    def default_source_archive_path
      ::File.join(Chef::Config[:file_cache_path], 'daemontools-0.76.tar.gz')
    end

    def default_source_directory
      ::File.join(Chef::Config[:file_cache_path], 'daemontools-0.76')
    end

    def default_svscan_service_name(install_style)
      return 'daemontools' if install_style.to_sym == :source

      platform?('debian', 'ubuntu') ? 'daemontools' : 'svscan'
    end

    def svscan_uses_systemd?
      !platform?('gentoo')
    end
  end
end
