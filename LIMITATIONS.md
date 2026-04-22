# Limitations

## Package Availability

### Debian and Ubuntu

- Debian ships both `daemontools` and `daemontools-run`; `daemontools-run` provides the service supervision bootstrap and `/etc/service`, so it is the correct package-oriented entry point for this cookbook on Debian-family systems.
- Debian 13 remains package-supported, so it should be part of the active validation set alongside Debian 12 while both releases are in support.
- Ubuntu ships both `daemontools` and `daemontools-run` in `universe`; `daemontools-run` is the package that wires `svscanboot` into the system and should be used for packaged installs.

### Arch Linux

- Arch Linux does not provide `daemontools` in the official repositories. The cookbook's Arch path is AUR-based and depends on the `pacman` cookbook plus `fakeroot`.
- The bundled AUR packaging installs daemontools under `/usr/bin`, expects `/etc/service`, and supplies a systemd unit for `svscan`.

### Gentoo

- Gentoo provides `sys-process/daemontools`.
- The Gentoo package path expects the traditional `/service` supervision directory, so package-based installs must keep `service_dir` set to `/service`.

### RHEL and Amazon Linux

- No current official distro package source was identified for `daemontools` on RHEL-family or Amazon Linux targets in this migration.
- On those platforms, the cookbook should treat source installation as the portable built-in path unless the operator supplies a local package and corresponding service manager integration.
- Existing RHEL-family support should be represented through current downstream test targets such as AlmaLinux 9 rather than through EOL CentOS releases.

## Architecture Limitations

- Debian and Ubuntu package builds are available on multiple architectures, including `amd64` and `arm64`.
- Gentoo marks `amd64`, `x86`, `arm`, `arm64`, `ppc`, and `ppc64` as available, with several other architectures keyworded or unstable.
- The bundled Arch PKGBUILD declares `i686`, `x86_64`, and `armv6h`; because this path is AUR-based, actual availability depends on the AUR package continuing to build on the target architecture.
- Source installation remains the broadest fallback, but it inherits compiler and libc compatibility constraints from the target platform toolchain.

## Source Installation

### Build Dependencies

| Platform Family | Packages |
| --- | --- |
| Debian | `build-essential`, `perl` |
| RHEL / Amazon | `gcc`, `make`, `perl` |
| Generic source path | `tar`, a working C toolchain, and `perl` |

### Source-Specific Constraints

- Upstream is still the historical `daemontools-0.76` tarball.
- The cookbook patches `src/error.h` during source builds to include `errno.h`, matching the long-standing compatibility fix required on modern toolchains.
- The stock upstream `svscanboot` expects `/command` and `/service`; the cookbook must continue to install a rewritten `svscanboot` script when using the source path so `bin_dir` and `service_dir` remain configurable.

## Known Issues

- CentOS Linux 7 and 8 are end-of-life and should not remain in the active support matrix.
- Ubuntu 20.04 standard maintenance ended on 2025-05-31; keeping it in the active test matrix would require treating ESM as a support baseline.
- Amazon Linux 2 reaches end of support on 2026-06-30, so new verification should prefer Amazon Linux 2023.
- Debian 11 security support ended on 2024-08-14 and its LTS window ends on 2026-08-31, so new validation should prefer Debian 12 or 13.
