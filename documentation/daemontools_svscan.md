# daemontools_svscan

Creates or manages the `svscan` bootstrap service for a chosen install style.

## Actions

| Action | Description |
| --- | --- |
| `:enable` | Ensures the supervision directory exists and enables or starts `svscan` (default) |
| `:disable` | Disables the `svscan` service when the platform service manager supports it |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance_name` | String | name property | Resource instance name |
| `install_style` | Symbol | required | One of `:source`, `:package`, or `:aur` |
| `bin_dir` | String | platform default | Directory containing `svscanboot` for source installs |
| `service_dir` | String | platform default | Directory scanned by `svscan` |
| `service_name` | String | derived from install style and platform | Service/unit name to manage |
| `source_directory` | String | Chef file cache path | Extracted source directory used for non-systemd source installs |
| `csh_package_name` | String | `'csh'` | Package used for non-systemd source bootstrap |

## Examples

```ruby
daemontools_svscan 'default' do
  install_style :source
  bin_dir '/usr/local/bin'
  service_dir '/etc/service'
end
```
