#
# Cookbook:: daemontools_test
# Recipe:: service
#
# The MIT License (MIT)
#
# Copyright:: 2020, Tomoya Kabe
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# For inspec to know the service directory path
file '/tmp/service-dir' do
  content node['daemontools']['service_dir']
end

daemontools_service 'enable-oneshot' do
  directory '/opt/enable-oneshot'
  cookbook cookbook_name
  template 'echo'
  log true
  action %i(enable)
end

daemontools_service 'invoke-oneshot' do
  directory '/opt/invoke-oneshot'
  cookbook cookbook_name
  template 'echo'
  log true
  down true
  action %i(enable once)
  # notifies :run, 'execute[ready-for-test]', :delayed
end

daemontools_service 'nolog-oneshot' do
  directory '/opt/nolog-oneshot'
  cookbook cookbook_name
  template 'echo'
  log false
  action %i(enable)
end

daemontools_service 'disable-oneshot' do
  directory '/opt/disable-oneshot'
  cookbook cookbook_name
  template 'echo'
  action %i(enable down disable)
end

execute 'ready-for-test' do
  command <<~EOCMD
    sleep 20
    svc -d #{node['daemontools']['service_dir']}/*
  EOCMD
  action :nothing
  subscribes :run, 'execute[start daemontools initially]'
end
