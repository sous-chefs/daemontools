# Description

Installs [DJB's Daemontools](http://cr.yp.to/daemontools.html) and includes a service LWRP.

# Requirements

## Platform:

Tested via [Test Kitchen](http://kitchen.ci).

* Debian 7.6
* Ubuntu 14.04, 12.04, 10.04

This cookbook is known in the past to work on ArchLinux and Gentoo, but as they are rolling release distributions, it is difficult to ensure compatibility over time.

May work on other platforms with or without modification using the "source" installation method. See __Attributes__ and __Recipes__ below.

## Cookbooks:

* pacman - for `aur` recipe, on ArchLinux systems
* build-essential - for `source` recipe

# Attributes

* `node['daemontools']['bin_dir']` - Sets the location of the binaries for daemontools, default is selected by platform, or '/usr/local/bin' as a fallback.
* `node['daemontools']['service_dir']` - Daemontools "service" directory where svscan will find services to manage.
* `node['daemontools']['install_method']` - how to install daemontools, can be `source`, `package` or `aur` (for ArchLinux).
* `node['daemontools']['start_svscan']` - whether to start `svscan` (includes the `svscan` recipe), `true` by default.
* `node['daemontools']['package_name']` - name of the "daemontools" package, default value varies by platform.

# Recipes

## default

The default recipe includes the appropriate installation method's recipe using the `node['daemontools']['install_method']` attribute.

If the `start_svscan` attribute is true, then include the `svscan` recipe too.

## package

Installs the `daemontools` package, using the `node['daemontools']['package_name']` attribute. On Debian family systems, this is `daemontools-run`, which depends on `daemontools` (and provides run time / init system configuration).

On other untested platforms (e.g., RHEL family), if a local `daemontools` package is built and it sets up the appropriate init system configuration (systemd, upstart, inittab), then this recipe will be sufficient. Otherwise, write a custom recipe.

## aur

Used on ArchLinux systems to install daemontools from the Arch User Repository (AUR). Exits gracefully without exception if used on other platforms.

## source

The source installation of daemontools should work on most other platforms that do not have a package available. A custom recipe may be required to configure the `svscan` service init script or upstart or systemd configuration.

## svscan

Enables and starts the `svscan` service. This requires that the local system have properly set up the `svscan` service for the appropriate init system. It's outside the scope of this cookbook to detect this for every possible platform, so a custom recipe may be required. For example, Debian family `daemontools-run` package provides this.

# Resource/Provider

This cookbook includes an LWRP, `daemontools_service`, for managing services with daemontools. Examples:

```ruby
daemontools_service "tinydns-internal" do
  directory "/etc/djbdns/tinydns-internal"
  template false
  action [:enable,:start]
end

daemontools_service "chef-client" do
  directory "/etc/sv/chef-client"
  template "chef-client"
  action [:enable,:start]
  log true
end
```

Daemontools itself can perform a number of actions on services. The following are commands sent via the `svc` program. See its man page for more information.

* start, stop, status, restart, up, down, once, pause, cont, hup, alrm, int, term, kill

Enabling a service (`:enable` action) is done by setting up the directory located by the `directory` resource attribute. The following are set up:

* `run` script that runs the service startup using the `template` resource attribute name.
* `log/run` directory and script that runs the logger if the resource attribute `log` is true.
* `finish` script, if specified using the `finish` resource attribute
* `env` directory, containing ENV variablesif specified with the `env` resource attribute
* links the `node['daemontools']['service_dir']/service_name` to the `service_name` directory.

The default action is `:start` - once enabled daemontools services are started by svscan anyway.

The name attribute for the resource is `service_name`.

# Usage

Include the daemontools recipe on nodes that should have daemontools installed for managing services. Use the `daemontools_service` LWRP for any services that should be managed by daemontools. In your cookbooks where `daemontools_service` is used, create the appropriate run and log-run scripts for your service. For example if the service is "flowers":

```ruby
daemontools_service "flowers" do
  directory "/etc/sv/flowers"
  template "flowers"
  action [:enable, :start]
  log true
end
```

Create these templates in your cookbook:

* `templates/default/sv-flowers-run.erb`
* `templates/default/sv-flowers-log-run.erb`

If your service also has a finish script, set the resource attribute `finish` to true and create `sv-flowers-finish.erb`.

The content of the scripts should be appropriate for the "flowers" service.

# License and Author

- Author: Joshua Timberman (<joshua@chef.io>)
- Copyright 2010-2012, Opscode, Inc.
- Copyright 2014, Chef Software, Inc. <legal@chef.io>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
