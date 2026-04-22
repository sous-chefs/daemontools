# frozen_string_literal: true

require_relative '../../spec_helper'

control 'daemontools-service-01' do
  impact 1.0
  title 'enabled services create the expected files'

  describe directory('/opt/enable-oneshot/log') do
    it { should exist }
    its('mode') { should cmp '0755' }
  end

  describe file('/opt/enable-oneshot/run') do
    it { should exist }
    its('mode') { should cmp '0755' }
  end

  describe file("#{daemontools_service_dir}/enable-oneshot") do
    it { should be_symlink }
  end

  describe directory('/opt/nolog-oneshot/log') do
    it { should_not exist }
  end
end

control 'daemontools-service-02' do
  impact 1.0
  title 'service actions manage logs and down files'

  describe file('/opt/enable-oneshot/log/main/current') do
    it { should exist }
    its('content') { should match(/Oneshot\n.*Oneshot/m) }
  end

  describe file('/opt/invoke-oneshot/down') do
    it { should exist }
    its('mode') { should cmp '0644' }
  end

  describe file('/opt/invoke-oneshot/log/main/current') do
    it { should exist }
    its('content') { should match(/Oneshot/) }
  end

  describe file("#{daemontools_service_dir}/disable-oneshot") do
    it { should_not exist }
  end
end
