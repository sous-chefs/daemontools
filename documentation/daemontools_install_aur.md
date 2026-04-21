# daemontools_install_aur

Installs daemontools from the Arch User Repository.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Builds and installs the configured AUR package (default) |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance_name` | String | name property | Resource instance name |
| `package_name` | String | `'daemontools'` | AUR package name |
| `service_dir` | String | `'/etc/service'` on supported platforms | Supervision directory expected by the package |
| `patches` | String, Array | `['daemontools-0.76.svscanboot-path-fix.patch']` | Local patches passed to `pacman_aur` |
| `build_packages` | String, Array | `['fakeroot']` | Packages required to build the AUR package |

## Examples

```ruby
daemontools_install_aur 'default' do
  package_name 'daemontools'
  service_dir '/etc/service'
end
```
