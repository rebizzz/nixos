# Hosts

This directory contains one subdirectory per machine. Each host directory wires together the
shared `base` module (in `base.nix`, one level up) with whichever system modules that host needs,
plus its own hardware/disk layout.

## Current Host Inventory

| Host                                  | Platform | Hardware                                 | Role                  | Status    |
| -------------------------------------- | -------- | ----------------------------------------- | ---------------------- | --------- |
| [`laptop`](laptop/README.md)           | NixOS    | Intel laptop, NVMe (LUKS + LVM + Btrfs)   | Daily-driver desktop   | ✅ Active |
| [`nixos-server`](nixos-server/README.md) | NixOS    | Intel box, Btrfs SSD + 2x HDD ZFS mirror  | Headless home server   | ✅ Active |

- **`laptop`**: `tmpfs` root wiped on every reboot, Umbriel + Noctalia desktop, home-manager.
- **`nixos-server`**: Btrfs root, also wiped every reboot (rolled back to a blank snapshot in
  initrd, see `_hardware.nix`'s `rollback-root` service, not tmpfs since it's a real disk). ZFS
  mirror for media/backup/storage, Docker, Cockpit, Tailscale, weekly self-upgrade. Administered
  remotely, see the repo root README for how `deploy-rs` is used.

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
modules, plus the `myConfig.hostClass` option (`"desktop"` or `"server"`) that a handful of shared
modules (`power`, `services`, `persistence`, see [../system/README.md](../system/README.md)) branch
on internally.

Everything else, host-class-specific by inclusion rather than by branching, is aggregated into one
named module per host rather than listed individually in `default.nix`:

- `laptop/profile.nix` defines `laptop-profile`, importing every desktop module (`audio`, `boot`,
  `desktop`, `gpu`, and so on) plus `base`.
- `nixos-server/profile.nix` defines `server-profile`, importing its own set (`autoupgrade`, `zfs`,
  `containers`, `motd`, `networking`, `security`) plus `base`, with `media` (Jellyfin) and `nixarr`
  left commented out as opt-in.

Each host's `default.nix` then references just its one profile module (plus home-manager on
`laptop`, and `_disko.nix`/`_hardware.nix` on both). This grouping follows the dendritic pattern's
own documented guidance against "lower-level module name proliferation" — see
[github.com/mightyiam/dendritic](https://github.com/mightyiam/dendritic#lower-level-module-name-proliferation).

Neither host auto-picks-up new modules. A new `.nix` file under `modules/system/` registers itself
(dendritic pattern, see [../system/README.md](../system/README.md)), but a host only gets it once
you add it to that host's `profile.nix` aggregator by name. This is more typing than an exclude
list, but it means you can diff a host's aggregator and see exactly what's on it, no separate
exclusion list to keep in sync.

GUI/desktop modules would either be meaningless or fail to evaluate on the headless server, since
several `nixos-server`-only modules read `hostVars`, a specialArg only `nixos-server` receives.

## Adding a New Host

1. Copy an existing host directory as a starting point:
   ```bash
   cp -r modules/hosts/nixos-server modules/hosts/<new-host>
   ```
2. Edit `_host.nix`: hostname, a fresh `hostId` (`head -c4 /dev/urandom | od -A none -t x4`),
   disks, wifi SSID, LAN IP, timezone.
3. Regenerate `_hardware.nix` from `nixos-generate-config` run on the target, and adapt `_disko.nix`
   to the target's actual disks.
4. Create a `profile.nix` aggregator for the new host (copy `laptop/profile.nix` or
   `nixos-server/profile.nix` as a starting point) listing the modules it needs, and reference it
   from `default.nix`.
5. Add the new host's age/ssh public key to `.sops.yaml` and run
   `sops updatekeys secrets/secrets.yaml`.
6. Install with [nixos-anywhere](https://github.com/nix-community/nixos-anywhere) or the standard
   disko + `nixos-install` flow described in the repo root README.
