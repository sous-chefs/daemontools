# frozen_string_literal: true

require 'spec_helper'

describe 'daemontools_svscan' do
  step_into :daemontools_svscan

  context 'with a source install on ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      daemontools_svscan 'default' do
        install_style :source
        bin_dir '/usr/local/bin'
      end
    end

    it { is_expected.to create_directory('/etc/service') }
    it { is_expected.to create_systemd_unit('daemontools.service') }
    it { is_expected.to enable_systemd_unit('daemontools.service') }
    it { is_expected.to start_systemd_unit('daemontools.service') }
  end

  context 'with a package install on ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      daemontools_svscan 'default' do
        install_style :package
      end
    end

    it { is_expected.to enable_service('daemontools') }
    it { is_expected.to start_service('daemontools') }
  end
end
