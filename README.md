# Description

[![Cookbook Version](https://img.shields.io/cookbook/v/daemontools.svg)](https://supermarket.chef.io/cookbooks/daemontools)
[![Build Status](https://img.shields.io/circleci/project/github/sous-chefs/daemontools/master.svg)](https://circleci.com/gh/sous-chefs/daemontools)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Installs [DJB's Daemontools](http://cr.yp.to/daemontools.html) and includes a service custom resource.

## Requirements

### Platform

Tested via [Test Kitchen](http://kitchen.ci).

- Ubuntu 20.04
- CentOS 7, 8
- AmazonLinux 2
- Gentoo
- ArchLinux

This cookbook is known in the past to work on ArchLinux and Gentoo, but as they are rolling release distributions, it is difficult to ensure compatibility over time.

May work on other platforms with or without modification using the "source" installation method. See __Attributes__ and __Recipes__ below.

### Depending Cookbooks

- pacman - for `aur` recipe, on ArchLinux systems
- build-essential - for `source` recipe

#### Attributes

- `node['daemontools']['bin_dir']` - Sets the location of the binaries for daemontools, default is selected by platform, or '/usr/local/bin' as a fallback.
- `node['daemontools']['service_dir']` - Daemontools "service" directory where svscan will find services to manage.
- `node['daemontools']['install_method']` - how to install daemontools, can be `source`, `package` or `aur` (for ArchLinux).
- `node['daemontools']['start_svscan']` - whether to start `svscan` (includes the `svscan` recipe), `true` by default.
- `node['daemontools']['package_name']` - name of the "daemontools" package, default value varies by platform.

## Recipes

### default

The default recipe includes the appropriate installation method's recipe using the `node['daemontools']['install_method']` attribute.

If the `start_svscan` attribute is true, then include the `svscan` recipe too.

### package

Installs the `daemontools` package, using the `node['daemontools']['package_name']` attribute. On Debian family systems, this is `daemontools-run`, which depends on `daemontools` (and provides run time / init system configuration).

On other untested platforms (e.g., RHEL family), if a local `daemontools` package is built and it sets up the appropriate init system configuration (systemd, upstart, inittab), then this recipe will be sufficient. Otherwise, write a custom recipe.

### aur

Used on ArchLinux systems to install daemontools from the Arch User Repository (AUR). Exits gracefully without exception if used on other platforms.

### source

The source installation of daemontools should work on most other platforms that do not have a package available. A custom recipe may be required to configure the `svscan` service init script or upstart or systemd configuration.

### svscan

Enables and starts the `svscan` service. This requires that the local system have properly set up the `svscan` service for the appropriate init system. It's outside the scope of this cookbook to detect this for every possible platform, so a custom recipe may be required. For example, Debian family `daemontools-run` package provides this.

## Resource

This cookbook includes a custom resource, `daemontools_service`, for managing services with daemontools. Examples:

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

- start, stop, status, restart, up, down, once, pause, cont, hup, alrm, int, term, kill

Enabling a service (`:enable` action) is done by setting up the directory located by the `directory` resource attribute. The following are set up:

- `run` script that runs the service startup using the `template` resource attribute name.
- `log/run` directory and script that runs the logger if the resource attribute `log` is true.
- `finish` script, if specified using the `finish` resource attribute
- `env` directory, containing ENV variables if specified with the `env` resource attribute
- links the `node['daemontools']['service_dir']/service_name` to the `service_name` directory.

The default action is `:start` - once enabled daemontools services are started by svscan anyway.

The name attribute for the resource is `service_name`.

## Usage

Include the daemontools recipe on nodes that should have daemontools installed for managing services. Use the `daemontools_service` custom resource for any services that should be managed by daemontools. In your cookbooks where `daemontools_service` is used, create the appropriate run and log-run scripts for your service. For example if the service is "flowers":

```ruby
daemontools_service "flowers" do
  directory "/etc/sv/flowers"
  template "flowers"
  action [:enable, :start]
  log true
end
```

Create these templates in your cookbook:

- `templates/default/sv-flowers-run.erb`
- `templates/default/sv-flowers-log-run.erb`

If your service also has a finish script, set the resource attribute `finish` to true and create `sv-flowers-finish.erb`.

The content of the scripts should be appropriate for the "flowers" service.

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/8/website](https://opencollective.com/sous-chefs/sponsor/8/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/9/website](https://opencollective.com/sous-chefs/sponsor/9/avatar.svg?avatarHeight=100)
