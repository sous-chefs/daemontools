# daemontools_install_package

Installs daemontools from a platform package.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Installs the configured daemontools package (default) |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance_name` | String | name property | Resource instance name |
| `package_name` | String | platform default | Package to install |
| `service_dir` | String | platform default | Expected supervision directory for the packaged install |

## Examples

```ruby
daemontools_install_package 'default' do
  package_name 'daemontools-run'
  service_dir '/etc/service'
end
```
