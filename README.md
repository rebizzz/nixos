# NixOS Config

[![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

![Desktop Preview](assets/preview.png)

This repository is home to the nix code that builds my systems:

1. **NixOS Desktop** (`laptop`): Niri + Noctalia on a `tmpfs` root, wiped on every reboot.
2. **NixOS Server** (`nixos-server`): a headless home server with a ZFS mirror, Docker, and
   Jellyfin, that auto-upgrades itself weekly.

Both hosts share one flake, one module tree, and one secrets file. See
[modules/hosts](modules/hosts/README.md) for details of each host.

## Tech Stack

- **OS:** NixOS (unstable)
- **Kernel:** `linuxPackages_latest`
- **WM:** [Niri](https://github.com/YaLTeR/niri) (scrollable tiling Wayland compositor), `laptop` only
- **Bar / Shell:** [Noctalia](https://github.com/noctalia-dev/noctalia), `laptop` only
- **Browser:** Brave Origin (debloated, locked-down policies)
- **Terminal:** Ghostty + Fish shell (`zoxide`, `eza`, `bat`, `ripgrep`)
- **Storage:** Btrfs + LUKS + LVM (`laptop`), Btrfs system disk + ZFS mirror data pool (`nixos-server`)
- **Containers / Media:** Docker, Jellyfin (opt-in), Cockpit, Tailscale, `nixos-server` only
- **Secrets:** [sops-nix](https://github.com/Mic92/sops-nix) with `age` keys
- **Remote deploy:** [colmena](https://github.com/nix-community/colmena), for pushing to `nixos-server`
- **Modules:** dendritic pattern via `flake-parts` + `import-tree`. Every file declares its own
  module, but each host lists which ones it actually uses (see
  [modules/hosts](modules/hosts/README.md)).

## Directory Structure

```
.
├── flake.nix               # Flake entrypoint (flake-parts + import-tree)
├── assets/                 # Wallpapers and avatar image
├── secrets/                # sops-nix encrypted secrets, shared by both hosts
└── modules/
    ├── hosts/              # One directory per machine, see modules/hosts/README.md
    ├── system/             # System modules (boot, hardware, services), see modules/system/README.md
    └── home/               # Home-Manager modules (apps, shell, theming), laptop only
```

Files prefixed with `_` (e.g. `_host.nix`, `_disko.nix`, `_hardware.nix`) are plain data/host
modules. `import-tree` otherwise treats every `.nix` file under `modules/` as a flake-parts module,
so these are deliberately excluded from that auto-discovery and wired in explicitly instead.

## Installing the Laptop

1. Boot NixOS installer and connect to Wi-Fi (`iwctl`).
2. Clone repo:
   ```bash
   nix-shell -p git -- git clone https://github.com/rebizzz/nixos /tmp/nixos
   cd /tmp/nixos
   ```
3. Run Disko to partition:
   ```bash
   sudo nix run github:nix-community/disko/latest -- --mode disko --flake .#laptop
   ```
4. Copy backup age key:
   ```bash
   sudo mkdir -p /mnt/persistent/etc/sops/age
   sudo cp /path/to/keys.txt /mnt/persistent/etc/sops/age/keys.txt
   sudo chmod 600 /mnt/persistent/etc/sops/age/keys.txt
   ```
5. Install and reboot:
   ```bash
   sudo nixos-install --flake .#laptop --no-root-passwd
   sudo reboot
   ```

Day to day, `sudo nixos-rebuild switch --flake .#laptop` or `just switch` both work.

## Deploying to the Server

`nixos-server` is administered remotely, there's no keyboard on it.

```bash
nix develop   # brings colmena, sops, age, just into PATH

# build without deploying, good for a quick sanity check
colmena build --on nixos-server
just server-build   # same thing

# build and deploy over SSH
colmena apply --on nixos-server
just server-apply   # same thing
```

The `nixos-server` colmena node (in `modules/hosts/nixos-server/default.nix`) connects as
`rebiz@nixos-server.local` and escalates via passwordless `sudo`. It's tagged `server`, so
`colmena apply --on @server` works too, useful once there's more than one server host.

Fallback without colmena:

```bash
nixos-rebuild switch --flake .#nixos-server --target-host rebiz@nixos-server.local --use-remote-sudo
```

For a from-scratch install, see [modules/hosts/README.md](modules/hosts/README.md).

## Common Commands

A `Justfile` wraps the commands above plus formatting and linting. Run `just --list` to see
everything, or `just` with no args does the same.

```bash
just fmt      # alejandra
just lint     # deadnix + statix + nix flake check
just update   # nix flake update
just gc       # garbage collect old generations, system and user
```

`direnv` is enabled on both hosts, and there's an `.envrc` at the repo root, so `cd`-ing in drops
you straight into the dev shell (colmena, sops, age, just) without typing `nix develop`. First
time in the repo, run `direnv allow` once.

## Secrets Management

See [secrets/README.md](secrets/README.md) for how sops-nix and age are set up and shared between
both hosts.

## License

[MIT](LICENSE)
