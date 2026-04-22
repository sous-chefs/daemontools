# frozen_string_literal: true

require 'spec_helper'

describe 'daemontools_install_package' do
  step_into :daemontools_install_package

  context 'on ubuntu' do
    platform 'ubuntu', '24.04'

    recipe do
      daemontools_install_package 'default'
    end

    it { is_expected.to install_package('daemontools-run') }
  end

  context 'on gentoo with the wrong service directory' do
    platform 'gentoo'

    recipe do
      daemontools_install_package 'default' do
        service_dir '/etc/service'
      end
    end

    it 'raises a validation error' do
      expect { chef_run }.to raise_error(RuntimeError, %r{must be /service})
    end
  end
end
