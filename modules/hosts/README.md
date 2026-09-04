# Hosts

This directory contains one subdirectory per machine. Each host directory wires together the
shared `base` module (in `base.nix`, one level up) with whichever system modules that host needs,
plus its own hardware/disk layout.

## Current Host Inventory

| Host                          | Platform | Hardware                                | Role                 | Status    |
| ------------------------------ | -------- | ----------------------------------------- | --------------------- | --------- |
| [`laptop`](laptop/README.md)   | NixOS    | Intel laptop, NVMe (LUKS + LVM + Btrfs)   | Daily-driver desktop   | ✅ Active |

- **`laptop`**: `tmpfs` root wiped on every reboot, Umbriel + Noctalia desktop, home-manager.

Files prefixed with `_` (`_host.nix`, `_disko.nix`, `_hardware.nix`) are plain data/host modules,
not flake-parts modules. `import-tree` skips them, so each host's `default.nix` imports them
explicitly by path instead.

## Naming Conventions

Codenamed after *Frieren: Beyond Journey's End*, purely a README nicety, `networking.hostName`
stays `nixos`, so remote reachability over mDNS doesn't depend on it:

- **`laptop`**: "Frieren", the one who takes the long view.

## How Module Wiring Works

`laptop` imports `inputs.self.modules.nixos.base` (defined in `../base.nix`), which carries what's
shared across the system: disko/preservation/sops-nix, direnv, and the `nix`/`secrets`/`user`
modules.

Every other system module the host needs is aggregated into one named module,
`laptop/profile.nix` defines `laptop-profile`, importing every desktop module (`audio`, `boot`,
`desktop`, `gpu`, and so on) plus `base`. `laptop/default.nix` then references just that one
profile module, plus home-manager and `_disko.nix`/`_hardware.nix`.

A new `.nix` file under `modules/system/` registers itself (dendritic pattern, see
[../system/README.md](../system/README.md)), but isn't live on the host until you add it to
`laptop/profile.nix` by name. This is more typing than an exclude list, but it means you can diff
the aggregator and see exactly what's on the host, no separate exclusion list to keep in sync.

## Adding a New Host

1. Create a new subdirectory under `modules/hosts/` with a `_host.nix` (hostname, a fresh `hostId`
   via `head -c4 /dev/urandom | od -A none -t x4`, disks, wifi SSID, timezone), a `_disko.nix`
   (adapt `laptop/_disko.nix` to the target's actual disks), and a `_hardware.nix` (regenerate with
   `nixos-generate-config` run on the target).
2. Create a `profile.nix` aggregator for the new host (copy `laptop/profile.nix` as a starting
   point) listing the modules it needs, and a `default.nix` that references it.
3. Add the new host's age/ssh public key to `.sops.yaml` and run
   `sops updatekeys secrets/secrets.yaml`.
4. Install with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) or the standard
   disko + `nixos-install` flow described in the repo root README.
