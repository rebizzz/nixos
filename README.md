<div align="center">

# nixos-config

**A fully declarative, tmpfs-root NixOS laptop config.**
Niri + Noctalia on top, a CachyOS-flavored kernel underneath, and nothing survives a reboot unless it's explicitly told to.

[![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?logo=nixos&logoColor=white)](https://nixos.org)
[![Flakes](https://img.shields.io/badge/Nix-flakes-informational?logo=nixos&logoColor=white)](https://nixos.wiki/wiki/Flakes)
[![flake-parts](https://img.shields.io/badge/flake--parts-dendritic-blueviolet)](https://flake.parts)
[![Niri](https://img.shields.io/badge/WM-Niri-orange)](https://github.com/YaLTeR/niri)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>

![Desktop Preview](assets/preview.png)

## What this actually is

Root is `tmpfs` and gets wiped on every boot. Nothing persists unless it's explicitly opted in via [`preservation`](https://github.com/nix-community/preservation) into `/persistent`. Combined with `sops-nix` for secrets and a fully flake-locked input set, the whole system is reproducible from this repo plus one age key — not "mostly reproducible, trust me."

Modules follow the **dendritic pattern**: every `.nix` file under `modules/` declares its own `flake.modules.{nixos,homeManager}.<name>`, auto-discovered via [`import-tree`](https://github.com/vic/import-tree) and composed with [`flake-parts`](https://flake.parts) — no central `imports = [...]` list to keep in sync by hand.

## Stack

| | |
|---|---|
| **Base** | NixOS (nixpkgs-unstable) |
| **Kernel** | [`linuxPackages_cachyos`](https://github.com/chaotic-cx/nyx) — BORE scheduler, ThinLTO, via chaotic-nyx |
| **Scheduler** | [sched-ext](https://github.com/sched-ext/scx) via `scx-loader` (CachyOS's own dbus scheduler manager), running `scx_lavd` |
| **WM** | [Niri](https://github.com/YaLTeR/niri) — scrollable-tiling Wayland compositor |
| **Shell / bar** | [Noctalia](https://github.com/noctalia-dev/noctalia) + Noctalia Greeter |
| **Terminal** | [Ghostty](https://ghostty.org) + Fish (`zoxide`, `eza`, `bat`, `ripgrep`) |
| **Browser** | Brave Origin, locked-down policies, no telemetry |
| **Editor** | Nano, syntax-highlighted |
| **Secrets** | [sops-nix](https://github.com/Mic92/sops-nix) + `age`, gated behind LUKS |
| **Root FS** | tmpfs + LUKS + LVM + Btrfs, `preservation` for opt-in persistence |
| **Networking** | NetworkManager on `iwd`, WiFi profiles declared via `ensureProfiles` + sops, DNS over TLS + DNSSEC via NextDNS |
| **Gaming** | Steam, Lutris, Proton — no GameMode (fights `ananicy-cpp` over process priority) |

## Highlights

- **Nothing drifts.** `users.mutableUsers = false` — the login password is enforced from the sops secret on every rebuild, not just at account creation. Same for WiFi: credentials live in `secrets.yaml`, not scattered across `nmcli` state.
- **Performance tuning matches CachyOS's own defaults** where it's actually portable to NixOS — sysctls (`vm.swappiness=150`, tuned dirty-bytes), zram+zstd, `rcutree.enable_rcu_lazy`, NTSYNC loaded for Proton — layered on a kernel pulled straight from chaotic-nyx rather than reinvented.
- **Encrypted at rest, twice over.** LUKS on disk, sops-nix on top, age key itself gated behind the LUKS unlock.
- **Atomic, not aspirational.** Every `nixos-rebuild switch` is a new generation you can boot straight back out of from the systemd-boot menu — no snapshot tooling bolted on after the fact.

## Layout

```
.
├── flake.nix               # inputs + flake-parts entrypoint
├── assets/                 # wallpaper, avatar, this README's preview
├── secrets/                # sops-nix encrypted secrets (secrets.yaml)
└── modules/
    ├── hosts/               # per-machine config (laptop: disko, hardware-scan)
    ├── system/               # NixOS modules — boot, core, desktop, hardware, services
    └── home/                 # Home Manager modules — apps, desktop, terminal
```

Every module is self-contained: it declares `flake.modules.nixos.<name>` (or `.homeManager.<name>`) and gets picked up automatically. Adding a new concern means adding a file, not editing a central list.

## Installing this on a new machine

1. Boot the NixOS installer, get online (`iwctl` for WiFi).
2. Clone the repo:
   ```bash
   nix-shell -p git -- git clone https://github.com/rebizzz/nixos /tmp/nixos
   cd /tmp/nixos
   ```
3. Partition with Disko (destructive — wipes the target disk):
   ```bash
   sudo nix run github:nix-community/disko/latest -- --mode disko --flake .#laptop
   ```
4. Drop in the age key so sops-nix can decrypt secrets on first boot:
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

## License

[MIT](LICENSE)
