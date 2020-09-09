#
# Cookbook:: daemontools
# Recipe:: svscan
#
# Author: Joshua Timberman <joshua@chef.io>
# Copyright:: 2014, Chef Software, Inc. <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

directory 'daemontools service directory' do
  path node['daemontools']['service_dir']
end

if node['daemontools']['install_method'] == 'source'
  if node['init_package'] == 'systemd'
    template '/usr/lib/systemd/system/daemontools.service' do
      source 'daemontools.service.erb'
      variables(
        bin_dir: node['daemontools']['bin_dir'],
        service_dir: node['daemontools']['service_dir']
      )
      notifies :run, 'execute[enable daemontools service]', :immediately
    end

    execute 'enable daemontools service' do
      command 'systemctl enable daemontools'
      action :nothing
      notifies :run, 'execute[reload systemd for daemontools service]', :immediately
    end

    execute 'reload systemd for daemontools service' do
      command 'systemctl daemon-reload'
      action :nothing
      notifies :run, 'execute[start daemontools initially]', :immediately
    end

    execute 'start daemontools initially' do
      command 'systemctl start daemontools'
      action :nothing
    end
  else
    package 'csh'

    bash 'register_service' do
      user 'root'
      not_if 'grep svscanboot /etc/rc.local'
      code '(cd /tmp/daemontools; package/run.rclocal)'
    end
  end
else
  service value_for_platform(
            %w(debian ubuntu) => {
              'default' => 'daemontools',
            },
            %w(redhat centos amazon arch gentoo) => {
              'default' => 'svscan',
            }
          ) do
    action [:enable, :start]
  end
end
