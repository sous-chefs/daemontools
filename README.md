# daemontools

[![Cookbook Version](https://img.shields.io/cookbook/v/daemontools.svg)](https://supermarket.chef.io/cookbooks/daemontools)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Custom resources for installing daemontools, managing `svscan`, and defining supervised services.

This cookbook no longer exposes recipes or node attributes as its public API. Use the resources directly.

## Supported Platforms

- Amazon Linux 2023
- Debian 12+
- Ubuntu 24.04+
- Arch Linux via AUR
- Gentoo via `sys-process/daemontools`

Current distro and packaging constraints are documented in [LIMITATIONS.md](LIMITATIONS.md).

## Resources

- `daemontools_install_source`
- `daemontools_install_package`
- `daemontools_install_aur`
- `daemontools_svscan`
- `daemontools_service`

Resource-specific documentation lives under `documentation/`.

## Usage

### Source install with managed `svscan`

```ruby
daemontools_install_source 'default' do
  bin_dir '/usr/local/bin'
  service_dir '/etc/service'
end

daemontools_svscan 'default' do
  install_style :source
  bin_dir '/usr/local/bin'
  service_dir '/etc/service'
end
```

### Debian or Ubuntu package install

```ruby
daemontools_install_package 'default' do
  package_name 'daemontools-run'
  service_dir '/etc/service'
end

daemontools_svscan 'default' do
  install_style :package
  service_name 'daemontools'
  service_dir '/etc/service'
end
```

### Arch Linux AUR install

```ruby
daemontools_install_aur 'default' do
  package_name 'daemontools'
  service_dir '/etc/service'
end

daemontools_svscan 'default' do
  install_style :aur
  service_name 'svscan'
  service_dir '/etc/service'
end
```

### Define a supervised service

```ruby
daemontools_service 'flowers' do
  directory '/etc/sv/flowers'
  template 'flowers'
  bin_dir '/usr/local/bin'
  service_dir '/etc/service'
  log true
  action %i(enable start)
end
```

Templates are still expected in the consuming cookbook:

- `templates/default/sv-flowers-run.erb`
- `templates/default/sv-flowers-log-run.erb`

If the service uses a finish script, set `finish true` and provide `sv-flowers-finish.erb`.

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
