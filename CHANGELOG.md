# daemontools

This file is used to list changes made in each version of the daemontools cookbook.

## 1.6.18 - *2025-09-04*

## 1.6.17 - *2025-09-04*

## 1.6.16 - *2024-05-06*

## 1.6.15 - *2024-05-06*

## 1.6.14 - *2023-11-01*

## 1.6.13 - *2023-10-03*

## 1.6.12 - *2023-10-03*

## 1.6.11 - *2023-07-10*

## 1.6.10 - *2023-05-17*

## 1.6.9 - *2023-05-03*

## 1.6.8 - *2023-04-01*

## 1.6.7 - *2023-03-02*

## 1.6.6 - *2023-02-14*

## 1.6.5 - *2023-02-14*

- Remove delivery folder

## 1.6.4 - *2022-01-06*

- resolved cookstyle error: recipes/svscan.rb:26:6 refactor: `Chef/Modernize/UseChefLanguageSystemdHelper`
- resolved cookstyle error: resources/service.rb:160:1 refactor: `Chef/Modernize/ClassEvalActionClass`

## 1.6.3 - *2021-08-29*

- Standardise files with files in sous-chefs/repo-management

## v1.6.1 (2020-10-26)

- Adapt to the latest cookstyle (6.21.1)

## v1.6.0 (2020-10-16)

- Transferred ownership to sous-chefs
- Updated supported platforms
- Rewrote for new (v12.5+) custom resource

## v1.5.0 (2014-12-30)

- Recursively create directory in `daemontools_service` provider (#16)
- Add `svscan` recipe for managing the `svscan` service so supervised services by `daemontools_service` work (#12, #21)
- Update test kitchen support, add tests (#18)
- Improve recipe readability, adding `package_name` attribute, and refactor `package`, `source` recipes
- Add `pacman` as a dependency so ArchLinux "just works"

## v1.4.0 (2014-12-15)

- Adding variables parameter to templates in service LWRP

## v1.3.0 (2014-04-23)

- COOK-2655 : Replace "execute" method with "`run_command_with_systems_locale`"

## v1.2.0 (2014-02-25)

- [COOK-4181] - Parameterize source tarball location

## v1.1.0

- **[COOK-3234](https://tickets.opscode.com/browse/COOK-3234)** - Fix issue where templates could not be updated after service is enabled
- **[COOK-3207](https://tickets.opscode.com/browse/COOK-3207)** - Add Gentoo platform support via package installation

## v1.0.2

- [COOK-2688]: missing space between link and name

## v1.0.0

- [COOK-1388] - Conditional fix-ups
- [COOK-1428] - Resolve foodcritic warnings
