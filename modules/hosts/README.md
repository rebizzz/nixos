# Hosts

This directory contains one subdirectory per machine. Each host directory wires together the
shared `base` module (in `base.nix`, one level up) with whichever system modules that host needs,
plus its own hardware/disk layout.

## Current Host Inventory

| Host                                  | Platform | Hardware                                 | Role                  | Status    |
| -------------------------------------- | -------- | ----------------------------------------- | ---------------------- | --------- |
| [`laptop`](laptop/README.md)           | NixOS    | Intel laptop, NVMe (LUKS + LVM + Btrfs)   | Daily-driver desktop   | ✅ Active |
| [`nixos-server`](nixos-server/README.md) | NixOS    | Intel box, Btrfs SSD + 2x HDD ZFS mirror  | Headless home server   | ✅ Active |

- **`laptop`**: `tmpfs` root wiped on every reboot, Niri + Noctalia desktop, home-manager.
- **`nixos-server`**: persistent Btrfs root, ZFS mirror for media/backup/storage, Docker, Cockpit,
  Tailscale, weekly self-upgrade. It's administered remotely, see the repo root README for how
  `colmena` is used.

Files prefixed with `_` (`_host.nix`, `_disko.nix`, `_hardware.nix`) are plain data/host modules,
not flake-parts modules. `import-tree` skips them, so each host's `default.nix` imports them
explicitly by path instead.

## Naming Conventions

Codenamed after *Frieren: Beyond Journey's End*, purely a README nicety, `networking.hostName`
stays `nixos` and `nixos-server`, so remote reachability over mDNS doesn't depend on it:

- **`laptop`**: "Frieren", the one who takes the long view.
- **`nixos-server`**: "Fern", the one who does the steady day to day work.

## How Module Wiring Differs Per Host

Both hosts import `inputs.self.modules.nixos.base` (defined in `../base.nix`), which only carries
what's genuinely common: disko/preservation/sops-nix, direnv, and the shared `nix`/`secrets`/`user`
modules. Everything else is host-class-specific and listed explicitly in each host's `default.nix`:

- `laptop/default.nix` lists every desktop module by name (`audio`, `boot`, `desktop`, `gpu`,
  `services`, and so on), plus home-manager and niri.
- `nixos-server/default.nix` lists its own set (`autoupgrade`, `zfs`, `containers`, `motd`,
  `networking`, `security`, `persistence-server`, `power-server`, `services-server`, plus the
  opt-in `media` for Jellyfin). GUI/desktop modules would either be meaningless or fail to evaluate
  on a headless box, since several read `hostVars`, a specialArg only `nixos-server` receives.

Neither host auto-picks-up new modules. A new `.nix` file under `modules/system/` registers itself
(dendritic pattern, see [../system/README.md](../system/README.md)), but a host only gets it once
you add it to that host's `modules` list by name. This is more typing than an exclude list, but it
means you can diff a host's `default.nix` and see exactly what's on it, no separate exclusion list
to keep in sync.

This split exists because a handful of module names are legitimately different per host class:
`power` vs `power-server`, `services` vs `services-server`, `persistence` vs `persistence-server`.
See [../system/README.md](../system/README.md) for why.

## Adding a New Host

1. Copy an existing host directory as a starting point:
   ```bash
   cp -r modules/hosts/nixos-server modules/hosts/<new-host>
   ```
2. Edit `_host.nix`: hostname, a fresh `hostId` (`head -c4 /dev/urandom | od -A none -t x4`),
   disks, wifi SSID, LAN IP, timezone.
3. Regenerate `_hardware.nix` from `nixos-generate-config` run on the target, and adapt `_disko.nix`
   to the target's actual disks.
4. Update `default.nix`'s module list for the new host's role (server-class vs desktop-class).
5. Add the new host's age/ssh public key to `.sops.yaml` and run
   `sops updatekeys secrets/secrets.yaml`.
6. Install with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) or the standard
   disko + `nixos-install` flow described in the repo root README.
