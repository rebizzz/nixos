# laptop

Daily-driver desktop, codenamed "Frieren" (see [../README.md](../README.md#naming-conventions)).
NixOS + preservation, `tmpfs` root wiped every reboot, LUKS + LVM + Btrfs on NVMe, Niri + Noctalia,
home-manager.

Disk layout is declarative via [disko](./_disko.nix), device `/dev/nvme0n1`.

Related:

- [../../../nixos-installer](../../../nixos-installer/README.md), iterate on disk layout without
  evaluating the full flake
- [_disko.nix](./_disko.nix)
- [_hardware.nix](./_hardware.nix)

Deploy: `sudo nixos-rebuild switch --flake .#laptop`, or `just switch`. See the repo root
[README](../../../README.md) for a from-scratch install.
