# frozen_string_literal: true

provides :daemontools_service
unified_mode true

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

include Daemontools::Helpers

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
property :bin_dir, String, default: lazy { default_runtime_bin_dir }
property :service_dir, String, default: lazy { default_service_dir }

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
      directory "#{new_resource.directory}/log/main" do
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

  link "#{new_resource.service_dir}/#{new_resource.service_name}" do
    to new_resource.directory
  end
end

action :disable do
  # https://cr.yp.to/daemontools/faq/create.html#remove
  execute "service #{new_resource.service_name} => disable" do
    command <<~EOCMD
      mv #{new_resource.service_dir}/#{new_resource.service_name} #{new_resource.service_dir}/.#{new_resource.service_name}
      cd #{new_resource.service_dir}/.#{new_resource.service_name} && #{new_resource.bin_dir}/svc -dx . log
      rm #{new_resource.service_dir}/.#{new_resource.service_name}
    EOCMD
    only_if { supervise_running(new_resource.directory, new_resource.bin_dir, new_resource.service_dir) }
  end
end

action :start do
  execute "service #{new_resource.service_name} => start" do
    command "#{new_resource.bin_dir}/svc -u #{new_resource.service_dir}/#{new_resource.service_name}"
    not_if { supervise_running(new_resource.directory, new_resource.bin_dir, new_resource.service_dir) }
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
      command "#{new_resource.bin_dir}/svc #{opt} #{new_resource.service_dir}/#{new_resource.service_name}"
      only_if { supervise_running(new_resource.directory, new_resource.bin_dir, new_resource.service_dir) }
    end
  end
end

action_class do
  include Daemontools::Helpers

  def shell_out_with_systems_locale(command, **opts)
    options = { environment: { 'LC_ALL' => nil } }.merge(opts)
    shell_out(command, **options)
  end

  def supervise_running(directory, bin_dir, service_dir)
    # Give svscan enough time to run supervise as it scans every 5 seconds
    if ::File.exist?(service_dir)
      ctime = ::File.ctime(service_dir)
      diff = Time.now - ctime
      sleep 6 - diff if diff < 6
    end
    shell_out("#{bin_dir}/svok #{directory}", environment: { 'LC_ALL' => nil }).exitstatus == 0
  end
end
