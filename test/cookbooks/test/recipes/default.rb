# frozen_string_literal: true

bin_dir = '/usr/local/bin'
service_dir = '/etc/service'

daemontools_install_source 'default' do
  bin_dir bin_dir
  service_dir service_dir
end

daemontools_svscan 'default' do
  install_style :source
  bin_dir bin_dir
  service_dir service_dir
end

file '/tmp/daemontools-bin-dir' do
  content bin_dir
end

file '/tmp/daemontools-service-dir' do
  content service_dir
end

file '/tmp/daemontools-svscan-service-name' do
  content 'daemontools'
end
