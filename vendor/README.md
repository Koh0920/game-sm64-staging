# Vendored runtime inputs

The staging snapshot builder cannot reliably reach GitHub Releases or Debian
package mirrors during a Dockerfile import. Runtime inputs are therefore pinned
in this GitHub Source repository.

## SM64CoopDX

- Release: `coop-deluxe/sm64coopdx` `v1.5.1`
- Asset: `sm64coopdx_Linux.zip`
- SHA-256:
  `4229f82fc4395e78faf192c910ffcfcc1d70f59a558cadf0f63ae548901fa5f5`

The release binary still requires a user-provided, valid US Super Mario 64 ROM
at runtime. No ROM is included in this repository or capsule.

## Debian runtime packages

`debs/` contains the packages needed by the official Linux binary on the pinned
Debian 12 GUI base image. They were resolved for `linux/amd64` with:

```bash
apt-get install --download-only --no-install-recommends \
  libgl1 libsdl2-2.0-0 libcurl4
```
