# frozen_string_literal: true

include_recipe 'test::default'

bin_dir = '/usr/local/bin'
service_dir = '/etc/service'

daemontools_service 'enable-oneshot' do
  directory '/opt/enable-oneshot'
  cookbook 'test'
  template 'echo'
  log true
  bin_dir bin_dir
  service_dir service_dir
  action :enable
end

daemontools_service 'invoke-oneshot' do
  directory '/opt/invoke-oneshot'
  cookbook 'test'
  template 'echo'
  log true
  down true
  bin_dir bin_dir
  service_dir service_dir
  action %i(enable once)
end

daemontools_service 'nolog-oneshot' do
  directory '/opt/nolog-oneshot'
  cookbook 'test'
  template 'echo'
  log false
  bin_dir bin_dir
  service_dir service_dir
  action :enable
end

daemontools_service 'disable-oneshot' do
  directory '/opt/disable-oneshot'
  cookbook 'test'
  template 'echo'
  bin_dir bin_dir
  service_dir service_dir
  action %i(enable down disable)
end

file '/tmp/daemontools-service-tests-ready' do
  content 'ready'
  action :nothing
end

chef_sleep 'wait for daemontools services' do
  seconds 10
  not_if { ::File.exist?('/tmp/daemontools-service-tests-ready') }
  notifies :create, 'file[/tmp/daemontools-service-tests-ready]', :immediately
end
