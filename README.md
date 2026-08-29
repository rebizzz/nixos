<h2 align="center">ReBiz's NixOS Config</h2>

<p align="center">
  <img src="assets/preview.png" width="640" alt="Desktop preview" />
</p>

<p align="center">
  <a href="https://nixos.org/"><img src="https://img.shields.io/badge/NixOS-unstable-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg?style=for-the-badge" alt="License: MIT"></a>
</p>

<p align="center">
  <em>"Since I have unlimited time, I thought I could get to know you slowly."</em>, Frieren
</p>

One flake, two machines, codenamed after Frieren's two steadiest travelers. `laptop` ("Frieren")
is a NixOS desktop with [Umbriel][Umbriel] + [Noctalia][Noctalia] on a `tmpfs` root wiped every reboot.
`nixos-server` ("Fern") is a headless home server with a ZFS mirror, Podman, and Jellyfin, that
self-upgrades weekly. See [modules/hosts](modules/hosts/README.md) for details of each host.

> :red_circle: **IMPORTANT**: **Don't deploy this flake directly on your own machine, it will not
> succeed.** It contains my hardware configuration (disk layout, LUKS device paths, `hostId`s) and
> its secrets are encrypted to my personal `age` key. Use it as a reference for your own config,
> not a drop-in install.

## Components

| Category | Choice |
| --- | --- |
| **Window Manager** | [Hyprland][Hyprland] |
| **Shell / Bar** | [Noctalia][Noctalia] |
| **Display Manager** | [greetd (tuigreet)][greetd] |
| **Terminal** | [kitty][kitty] + [Fish][Fish] (`zoxide`, `eza`, `bat`, `ripgrep`) |
| **Browser** | Brave Origin, debloated and locked down via policy |
| **Filesystem** | Btrfs + LUKS + LVM (`laptop`), Btrfs system disk + ZFS mirror (`nixos-server`) |
| **Secrets** | [sops-nix][sops-nix] + `age` |
| **Remote Deploy** | [deploy-rs][deploy-rs], for pushing to `nixos-server` |
| **Containers / Media** | Podman, [Nixarr Media Stack](docs/nixarr.md) (Jellyfin, Sonarr, Radarr, Prowlarr, FlareSolverr, Transmission, Bazarr, Recyclarr), Cockpit, [Tailscale][Tailscale] |
| **Modules** | dendritic pattern via [flake-parts][flake-parts] + [import-tree][import-tree] |

## Directory Structure

```
.
├── flake.nix    # Flake entrypoint (flake-parts + import-tree)
├── Justfile     # just --list for build/lint/deploy shortcuts
├── assets/      # Wallpapers and avatar image
├── secrets/     # sops-nix encrypted secrets, shared by both hosts
└── modules/     # see modules/README.md
    ├── flake/   # flake-parts wiring: devShell
    ├── hosts/   # One directory per machine
    ├── system/  # NixOS modules (boot, hardware, services)
    └── home/    # Home Manager modules, laptop only
```

Files prefixed with `_` (e.g. `_host.nix`, `_disko.nix`, `_hardware.nix`) are plain data/host
modules. `import-tree` otherwise treats every `.nix` file under `modules/` as a flake-parts module,
so these are deliberately excluded from that auto-discovery and wired in explicitly instead. Each
host also lists the exact set of modules it uses, see [modules/hosts](modules/hosts/README.md) for
why that's explicit rather than automatic.

## Installing the Laptop

1. Boot the NixOS installer and connect to Wi-Fi (`iwctl`).
2. Clone the repo:
   ```bash
   nix-shell -p git -- git clone https://github.com/rebizzz/nixos /tmp/nixos
   cd /tmp/nixos
   ```
3. Partition with Disko:
   ```bash
   sudo nix run github:nix-community/disko/latest -- --mode disko --flake .#laptop
   ```
4. Copy the backup `age` key:
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

Day to day: `just switch`.

## Deploying to the Server

`nixos-server` is administered remotely, there's no keyboard on it.

```bash
nix build .#nixosConfigurations.nixos-server.config.system.build.toplevel   # build only, good for a quick sanity check
deploy .#nixos-server   # build and deploy over SSH
```

The `nixos-server` deploy-rs node (in `modules/hosts/nixos-server/default.nix`) connects as
`rebiz@nixos-server.local` and escalates via passwordless `sudo`.

Fallback without deploy-rs:

```bash
nixos-rebuild switch --flake .#nixos-server --target-host rebiz@nixos-server.local --use-remote-sudo
```

For a from-scratch install, see [modules/hosts/README.md](modules/hosts/README.md). For how
secrets are shared between both hosts, see [secrets/README.md](secrets/README.md). For the complete
media automation setup and architecture, see the [Nixarr Stack Guide](docs/nixarr.md).

## Development

[direnv][direnv] is enabled on both hosts. Approve it once with `direnv allow`, and from then on
`cd`-ing into the repo loads `deploy-rs`, `sops`, `age`, and `just` automatically, no `nix develop`
needed. The `Justfile` wraps formatting, linting, and the deploy commands above:

```bash
just fmt      # alejandra
just lint     # deadnix + statix + nix flake check
just update   # nix flake update
just gc       # garbage collect old generations, system and user
```

Run `just --list` to see every recipe.

---

## References

- [mightyiam/dendritic][dendritic]
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)

[MIT licensed](LICENSE).

[Hyprland]: https://hyprland.org
[Noctalia]: https://github.com/noctalia-dev/noctalia
[greetd]: https://github.com/tuigreet/tuigreet
[kitty]: https://sw.kovidgoyal.net/kitty/
[Fish]: https://fishshell.com/
[sops-nix]: https://github.com/Mic92/sops-nix
[deploy-rs]: https://github.com/serokell/deploy-rs
[Jellyfin]: https://jellyfin.org/
[Tailscale]: https://tailscale.com/
[flake-parts]: https://flake.parts/
[import-tree]: https://github.com/vic/import-tree
[direnv]: https://direnv.net/
[dendritic]: https://github.com/mightyiam/dendritic
