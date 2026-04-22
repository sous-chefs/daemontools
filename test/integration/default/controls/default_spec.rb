# frozen_string_literal: true

require_relative '../../spec_helper'

control 'daemontools-install-01' do
  impact 1.0
  title 'daemontools binaries are installed from source'

  describe file("#{daemontools_bin_dir}/svc") do
    it { should exist }
    it { should be_executable }
  end

  describe file("#{daemontools_bin_dir}/svscanboot") do
    it { should exist }
    its('content') { should match(/#{Regexp.escape(daemontools_service_dir)}/) }
  end
end

control 'daemontools-svscan-01' do
  impact 1.0
  title 'svscan is enabled and running'

  describe directory(daemontools_service_dir) do
    it { should exist }
  end

  describe systemd_service(daemontools_svscan_service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end

  describe processes('svscan') do
    it { should exist }
  end
end
