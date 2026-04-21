# daemontools_service

Manages a supervised service directory and sends control commands through `svc`.

## Actions

| Action | Description |
| --- | --- |
| `:enable` | Creates the service directory structure and links it into `service_dir` |
| `:disable` | Removes a supervised service according to daemontools removal guidance |
| `:start` | Sends `svc -u` to the service (default) |
| `:stop` | Sends `svc -p` to the service |
| `:restart` | Sends `svc -t` to the service |
| `:up` | Sends `svc -u` to the service |
| `:down` | Sends `svc -d` to the service |
| `:once` | Sends `svc -o` to the service |
| `:pause` | Sends `svc -p` to the service |
| `:cont` | Sends `svc -c` to the service |
| `:hup` | Sends `svc -h` to the service |
| `:alrm` | Sends `svc -a` to the service |
| `:int` | Sends `svc -i` to the service |
| `:term` | Sends `svc -t` to the service |
| `:kill` | Sends `svc -k` to the service |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `service_name` | String | name property | Service name linked under `service_dir` |
| `directory` | String | required | Directory containing the service definition |
| `template` | String, false | `false` | Template prefix used for `run`, `log/run`, and `finish` scripts |
| `cookbook` | String | current cookbook lookup | Cookbook that provides templates |
| `variables` | Hash | `{}` | Variables passed to templates |
| `owner` | Integer, String | nil | Owner for created files and directories |
| `group` | Integer, String | nil | Group for created files and directories |
| `finish` | true, false | nil | Whether to create a `finish` script |
| `log` | true, false | nil | Whether to create a `log/run` script |
| `env` | Hash | `{}` | Environment files to write under `env/` |
| `down` | true, false | `false` | Whether to create the `down` file |
| `bin_dir` | String | platform default | Directory containing `svc` and `svok` |
| `service_dir` | String | platform default | Supervision directory where the service symlink is created |

## Examples

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
