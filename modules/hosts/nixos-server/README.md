# nixos-server

Headless home server, codenamed "Fern" (see [../README.md](../README.md#naming-conventions)).
Persistent Btrfs root, ZFS mirror for media/backup, Docker, Cockpit, Tailscale, weekly
self-upgrade. Administered remotely via colmena, no keyboard attached.

Disk layout is declarative via [disko](./_disko.nix): Btrfs system disk (`/dev/sda`) plus a ZFS
mirror across `/dev/sdb` and `/dev/sdc`.

Related:

- [_host.nix](./_host.nix), hostname, `hostId`, disks, wifi SSID, timezone
- [_disko.nix](./_disko.nix)
- [_hardware.nix](./_hardware.nix)

Deploy: `colmena apply --on nixos-server`, or `just server-apply`. See the repo root
[README](../../../README.md) for the from-scratch nixos-anywhere flow.
