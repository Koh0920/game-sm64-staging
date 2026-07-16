# Vendored runtime inputs

The staging snapshot builder cannot reliably reach GitHub Releases or Debian
package mirrors during a Dockerfile import. Runtime inputs are therefore pinned
in this GitHub Source repository.

## SM64CoopDX

- Release: `coop-deluxe/sm64coopdx` `v1.5.1`
- Asset: `sm64coopdx_Linux.zip`
- SHA-256:
  `4229f82fc4395e78faf192c910ffcfcc1d70f59a558cadf0f63ae548901fa5f5`

## Super Mario 64 (USA) ROM

**STAGING ONLY — do not merge to production.**

The sm64coopdx binary requires a valid US Super Mario 64 ROM for asset
extraction at first run. This file is included in the staging capsule only.

- Source: Internet Archive (`super-mario-64-usa_202401`)
- File: `baserom.us.z64`
- SHA-1: `9bef1128717f958171a4afac3ed78ee2bb4e86ce`
- Size: 8.0 MiB

## Debian runtime packages

`debs/` contains the packages needed by the official Linux binary on the pinned
Debian 12 GUI base image. They were resolved for `linux/amd64` with:

```bash
apt-get install --download-only --no-install-recommends \
  libgl1 libsdl2-2.0-0 libcurl4
```
