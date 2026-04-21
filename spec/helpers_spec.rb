# frozen_string_literal: true

require 'spec_helper'
require_relative '../libraries/helpers'

describe Daemontools::Helpers do
  subject(:helper_host) do
    Class.new do
      include Daemontools::Helpers

      attr_reader :node

      def initialize(platform, platform_family)
        @node = Chef::Node.new
        @node.automatic['platform'] = platform
        @node.automatic['platform_family'] = platform_family
      end

      def platform?(*platforms)
        platforms.include?(node['platform'])
      end

      def platform_family?(*platform_families)
        platform_families.include?(node['platform_family'])
      end
    end.new(platform, platform_family)
  end

  context 'on ubuntu' do
    let(:platform) { 'ubuntu' }
    let(:platform_family) { 'debian' }

    it 'derives the packaged install defaults' do
      expect(helper_host.default_package_name).to eq('daemontools-run')
      expect(helper_host.default_runtime_bin_dir).to eq('/usr/bin')
      expect(helper_host.default_service_dir).to eq('/etc/service')
      expect(helper_host.default_svscan_service_name(:package)).to eq('daemontools')
    end

    it 'derives source build packages' do
      expect(helper_host.default_source_build_packages).to eq(%w(build-essential perl))
    end
  end

  context 'on gentoo' do
    let(:platform) { 'gentoo' }
    let(:platform_family) { 'gentoo' }

    it 'preserves the traditional service directory' do
      expect(helper_host.default_package_name).to eq('sys-process/daemontools')
      expect(helper_host.default_service_dir).to eq('/service')
    end
  end
end
