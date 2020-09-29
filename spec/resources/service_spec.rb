require 'spec_helper'

describe 'service' do
  step_into :daemontools_service
  platform 'ubuntu'

  default_attributes['daemontools']['service_dir'] = '/etc/service'

  context 'Launch daemontools service with log' do
    recipe do
      daemontools_service 'enable-oneshot' do
        directory '/opt/enable-oneshot'
        cookbook 'daemontools_test'
        template 'echo'
        log true
        action %i(enable)
      end
    end

    it 'generates a good run file' do
      is_expected.to create_template('/opt/enable-oneshot/run')
    end

    it 'generates a good log run file' do
      is_expected.to create_template('/opt/enable-oneshot/log/run')
    end
  end

  context 'Launch daemontools service with template variable' do
    recipe do
      daemontools_service 'enable-oneshot' do
        directory '/opt/x'
        cookbook 'daemontools_test'
        template 'x'
        log false
        action %i(enable)
        variables(
          message: 'hello'
        )
      end
    end

    it 'generates a good run file' do
      is_expected.to create_template('/opt/x/run').with_variables(
        variables: { message: 'hello' }
      )
    end

    describe 'it does not generate log run file' do
      it { is_expected.not_to render_file('/opt/x/log/run') }
    end
  end
end
