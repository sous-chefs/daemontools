# frozen_string_literal: true

require 'spec_helper'

describe 'daemontools_install_aur' do
  step_into :daemontools_install_aur
  platform 'arch'

  recipe do
    daemontools_install_aur 'default'
  end

  it { is_expected.to include_recipe('pacman::default') }
  it { is_expected.to install_package('fakeroot') }

  it 'configures the pacman_aur resource' do
    aur_resource = chef_run.find_resource('pacman_aur', 'daemontools')

    expect(aur_resource.patches).to eq(['daemontools-0.76.svscanboot-path-fix.patch'])
    expect(aur_resource.action).to eq(%i(build install))
  end
end
