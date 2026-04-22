# frozen_string_literal: true

require 'spec_helper'

describe 'daemontools_install_source' do
  step_into :daemontools_install_source
  platform 'ubuntu', '24.04'

  recipe do
    daemontools_install_source 'default'
  end

  it { is_expected.to install_package('build-essential') }
  it { is_expected.to install_package('perl') }
  it { is_expected.to create_remote_file("#{Chef::Config[:file_cache_path]}/daemontools-0.76.tar.gz") }
  it { is_expected.to create_directory(Chef::Config[:file_cache_path] + '/daemontools-0.76') }
  it { is_expected.to run_execute('extract default source') }
  it { is_expected.to run_execute('compile default source') }
  it { is_expected.to create_template('/usr/local/bin/svscanboot') }
end
