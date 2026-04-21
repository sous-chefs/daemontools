# frozen_string_literal: true

require 'spec_helper'

describe 'daemontools_service' do
  step_into :daemontools_service
  platform 'ubuntu', '24.04'

  context 'with logging enabled' do
    recipe do
      daemontools_service 'enable-oneshot' do
        directory '/opt/enable-oneshot'
        cookbook 'test'
        template 'echo'
        log true
        bin_dir '/usr/local/bin'
        service_dir '/etc/service'
        action :enable
      end
    end

    it { is_expected.to create_template('/opt/enable-oneshot/run') }
    it { is_expected.to create_template('/opt/enable-oneshot/log/run') }
    it { is_expected.to create_link('/etc/service/enable-oneshot').with(to: '/opt/enable-oneshot') }
  end

  context 'with template variables and down state' do
    recipe do
      daemontools_service 'invoke-oneshot' do
        directory '/opt/invoke-oneshot'
        cookbook 'test'
        template 'x'
        log false
        down true
        bin_dir '/usr/local/bin'
        service_dir '/etc/service'
        variables(message: 'hello')
        action :enable
      end
    end

    it do
      is_expected.to create_template('/opt/invoke-oneshot/run').with_variables(
        variables: { message: 'hello' }
      )
    end

    it { is_expected.not_to render_file('/opt/invoke-oneshot/log/run') }
    it { is_expected.to create_file('/opt/invoke-oneshot/down') }
  end
end
