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

This repository is home to the nix code that builds my systems, codenamed after Frieren's two
steadiest travelers:

1. **`laptop`** ("Frieren"): NixOS desktop, [Niri][Niri] + [Noctalia][Noctalia] on a `tmpfs` root
   wiped every reboot. Always around, rebuilt from scratch each time and none the worse for it.
2. **`nixos-server`** ("Fern"): headless home server, ZFS mirror, Docker, Jellyfin, self-upgrades
   weekly. Does the unglamorous work quietly in the background.

Both hosts share one flake, one module tree, and one secrets file. See
[modules/hosts](modules/hosts/README.md) for details of each host.

> :red_circle: **IMPORTANT**: **Don't deploy this flake directly on your own machine, it will not
> succeed.** It contains my hardware configuration (disk layout, LUKS device paths, `hostId`s) and
> its secrets are encrypted to my personal `age` key. Use it as a reference for your own config,
> not a drop-in install.

## Components

| |  |
| --- | --- |
| **Window Manager** | [Niri][Niri] |
| **Shell / Bar** | [Noctalia][Noctalia] |
| **Display Manager** | [noctalia-greeter][noctalia-greeter] |
| **Terminal** | [Ghostty][Ghostty] + [Fish][Fish] (`zoxide`, `eza`, `bat`, `ripgrep`) |
| **Browser** | Brave Origin, debloated and locked down via policy |
| **Filesystem** | Btrfs + LUKS + LVM (`laptop`), Btrfs system disk + ZFS mirror (`nixos-server`) |
| **Secrets** | [sops-nix][sops-nix] + `age` |
| **Remote Deploy** | [colmena][colmena], for pushing to `nixos-server` |
| **Containers / Media** | Docker, [Jellyfin][Jellyfin] (opt-in), Cockpit, [Tailscale][Tailscale] |
| **Modules** | dendritic pattern via [flake-parts][flake-parts] + [import-tree][import-tree] |

## Directory Structure

```
.
├── flake.nix    # Flake entrypoint (flake-parts + import-tree)
├── Justfile     # just --list for build/lint/deploy shortcuts
├── assets/      # Wallpapers and avatar image
├── secrets/     # sops-nix encrypted secrets, shared by both hosts
└── modules/     # see modules/README.md
    ├── flake/   # flake-parts wiring: devShell, colmena hive
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

Day to day: `just switch` (wraps `nh os switch`, shows a generation diff), or plain
`sudo nixos-rebuild switch --flake .#laptop` if `nh` isn't available yet.

## Deploying to the Server

`nixos-server` is administered remotely, there's no keyboard on it.

```bash
colmena build --on nixos-server   # build only, good for a quick sanity check
colmena apply --on nixos-server   # build and deploy over SSH
```

The `nixos-server` colmena node (in `modules/hosts/nixos-server/default.nix`) connects as
`rebiz@nixos-server.local` and escalates via passwordless `sudo`. It's tagged `server`, so
`colmena apply --on @server` also works, useful once there's more than one server host.

Fallback without colmena:

```bash
nixos-rebuild switch --flake .#nixos-server --target-host rebiz@nixos-server.local --use-remote-sudo
```

For a from-scratch install, see [modules/hosts/README.md](modules/hosts/README.md).

## Development Shell

[direnv][direnv] is enabled on both hosts, with an `.envrc` at the repo root. Approve it once:

```bash
direnv allow
```

After that, `cd`-ing into the repo loads `colmena`, `sops`, `age`, and `just` automatically.
Without direnv, `nix develop` does the same thing manually.

## Common Commands

The `Justfile` wraps the commands above plus formatting and linting, run `just --list` to see
everything:

```bash
just fmt      # alejandra
just lint     # deadnix + statix + nix flake check
just update   # nix flake update
just gc       # garbage collect old generations, system and user
```

## Secrets Management

See [secrets/README.md](secrets/README.md) for how sops-nix and age are set up and shared between
both hosts.

## References

- [mightyiam/dendritic][dendritic]
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/)

## License

[MIT](LICENSE)

[Niri]: https://github.com/YaLTeR/niri
[Noctalia]: https://github.com/noctalia-dev/noctalia
[noctalia-greeter]: https://github.com/noctalia-dev/noctalia-greeter
[Ghostty]: https://github.com/ghostty-org/ghostty
[Fish]: https://fishshell.com/
[sops-nix]: https://github.com/Mic92/sops-nix
[colmena]: https://github.com/nix-community/colmena
[Jellyfin]: https://jellyfin.org/
[Tailscale]: https://tailscale.com/
[flake-parts]: https://flake.parts/
[import-tree]: https://github.com/vic/import-tree
[direnv]: https://direnv.net/
[dendritic]: https://github.com/mightyiam/dendritic
