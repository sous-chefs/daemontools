# daemontools_install_source

Installs daemontools from the upstream source tarball and writes a configurable `svscanboot`.

## Actions

| Action | Description |
| --- | --- |
| `:create` | Installs build dependencies, compiles daemontools, and writes `svscanboot` (default) |

## Properties

| Property | Type | Default | Description |
| --- | --- | --- | --- |
| `instance_name` | String | name property | Resource instance name |
| `bin_dir` | String | `'/usr/local/bin'` | Directory where daemontools commands are installed |
| `service_dir` | String | platform default | Directory scanned by `svscan` |
| `source_url` | String | `'http://cr.yp.to/daemontools/daemontools-0.76.tar.gz'` | Upstream source tarball |
| `source_checksum` | String | cookbook default | SHA256 checksum for the source tarball |
| `build_packages` | String, Array | platform default | Packages needed to compile daemontools |
| `source_archive_path` | String | Chef file cache path | Local tarball cache path |
| `source_directory` | String | Chef file cache path | Extracted source directory |

## Examples

```ruby
daemontools_install_source 'default' do
  bin_dir '/usr/local/bin'
  service_dir '/etc/service'
end
```
