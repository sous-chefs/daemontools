#
# Cookbook:: daemontools
# Resource:: service
#
# Copyright:: 2010, Opscode, Inc.
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

# -u: Up. If the service is not running, start it. If the service stops, restart it.
# -d: Down. If the service is running, send it a TERM signal and then a CONT signal. After it stops, do not restart it.
# -o: Once. If the service is not running, start it. Do not restart it if it stops.
# -p: Pause. Send the service a STOP signal.
# -c: Continue. Send the service a CONT signal.
# -h: Hangup. Send the service a HUP signal.
# -a: Alarm. Send the service an ALRM signal.
# -i: Interrupt. Send the service an INT signal.
# -t: Terminate. Send the service a TERM signal.
# -k: Kill. Send the service a KILL signal.

default_action :start

property :service_name, String, name_property: true
property :directory, String, required: true
property :template, [String, false], default: false
property :cookbook, String
property :variables, Hash, default: {}
property :owner, [Integer, String], regex: Chef::Config['user_valid_regex']
property :group, [Integer, String], regex: Chef::Config['group_valid_regex']
property :finish, [true, false]
property :log, [true, false]
property :env, Hash, default: {}
property :down, [true, false], default: false

action :enable do
  directory new_resource.directory do
    owner new_resource.owner
    group new_resource.group
    recursive true
    mode '0755'
  end

  if new_resource.template
    template "#{new_resource.directory}/run" do
      source "sv-#{new_resource.template}-run.erb"
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      variables(variables: new_resource.variables) unless new_resource.variables.empty?
    end
    if new_resource.log
      directory "#{new_resource.directory}/log" do
        owner new_resource.owner
        group new_resource.group
        mode '0755'
      end
      template "#{new_resource.directory}/log/run" do
        source "sv-#{new_resource.template}-log-run.erb"
        cookbook new_resource.cookbook
        owner new_resource.owner
        group new_resource.group
        mode '0755'
        variables(variables: new_resource.variables) unless new_resource.variables.empty?
      end
    end
    template "#{new_resource.directory}/finish" do
      source "sv-#{new_resource.template}-finish.erb"
      cookbook new_resource.cookbook
      owner new_resource.owner
      group new_resource.group
      mode '0755'
      variables(variables: new_resource.variables) unless new_resource.variables.empty?
      only_if { new_resource.finish }
    end
  end

  file "#{new_resource.directory}/down" do
    owner new_resource.owner
    group new_resource.group
    mode '0644'
    content ''
    action new_resource.down ? :create : :delete
  end

  unless new_resource.env.empty?
    directory "#{new_resource.directory}/env" do
      owner new_resource.owner
      group new_resource.group
      mode '0755'
    end
    new_resource.env.each do |var, value|
      file "#{new_resource.directory}/env/#{var}" do
        content value
        owner new_resource.owner
        group new_resource.group
        mode '0644'
      end
    end
  end

  link "#{node['daemontools']['service_dir']}/#{new_resource.service_name}" do
    to new_resource.directory
  end
end

action :disable do
  # https://cr.yp.to/daemontools/faq/create.html#remove
  execute "service #{new_resource.service_name} => disable" do
    command <<~EOCMD
      mv #{node['daemontools']['service_dir']}/#{new_resource.service_name} #{node['daemontools']['service_dir']}/.#{new_resource.service_name}
      cd #{node['daemontools']['service_dir']}/.#{new_resource.service_name} && svc -dx . log
      rm #{node['daemontools']['service_dir']}/.#{new_resource.service_name}
    EOCMD
    only_if { supervise_running(new_resource.directory) }
  end
end

action :start do
  execute "service #{new_resource.service_name} => start" do
    command "svc -u #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
    not_if { supervise_running(new_resource.directory) }
  end
end

SVC_ACTIONS = {
  stop: '-p',
  restart: '-t',
  up: '-u',
  down: '-d',
  once: '-o',
  pause: '-p',
  cont: '-c',
  hup: '-h',
  alrm: '-a',
  int: '-i',
  term: '-t',
  kill: '-k',
}.freeze

SVC_ACTIONS.each do |act, opt|
  action act do
    execute "service #{new_resource.service_name} => #{act}" do
      command "svc #{opt} #{node['daemontools']['service_dir']}/#{new_resource.service_name}"
      only_if { supervise_running(new_resource.directory) }
    end
  end
end

action_class.class_eval do
  def shell_out_with_systems_locale(command, **opts)
    options = { environment: { 'LC_ALL' => nil } }.merge(opts)
    shell_out(command, **options)
  end

  def supervise_running(directory)
    # Give svscan enough time to run supervise as it scans every 5 seconds
    if ::File.exist?(node['daemontools']['service_dir'])
      ctime = ::File.ctime(node['daemontools']['service_dir'])
      diff = Time.now - ctime
      sleep 6 - diff if diff < 6
    end
    shell_out("svok #{directory}", environment: { 'LC_ALL' => nil }).exitstatus == 0
  end
end
