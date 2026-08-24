# Installer Flake

A minimal flake for iterating on `laptop`'s disk layout and hardware config on real hardware,
without evaluating the whole main flake, which takes ~30s per evaluation once fetched, and pulls
in home-manager, umbriel, noctalia, and every other module along with it.

This flake doesn't duplicate the disk layout, it imports the real
[`_disko.nix`](../modules/hosts/laptop/_disko.nix) and
[`_hardware.nix`](../modules/hosts/laptop/_hardware.nix) directly from the main flake, so there's
one source of truth and no drift between "what I tested" and "what actually deploys."

> :red_circle: **IMPORTANT**: **Don't run this against a disk you care about.** The disko step
> below is destructive.

## Steps

1. Boot the NixOS installer and connect to Wi-Fi (`iwctl`).
2. Clone the repo:
   ```bash
   nix-shell -p git -- git clone https://github.com/rebizzz/nixos /tmp/nixos
   cd /tmp/nixos/nixos-installer
   ```
3. Partition and format with disko:
   ```bash
   sudo nix run github:nix-community/disko/latest -- --mode disko --flake .#laptop
   ```
4. Install:
   ```bash
   sudo nixos-install --root /mnt --flake .#laptop --no-root-password
   ```
5. Copy the backup `age` key into the new system before rebooting:
   ```bash
   sudo mkdir -p /mnt/persistent/etc/sops/age
   sudo cp /path/to/keys.txt /mnt/persistent/etc/sops/age/keys.txt
   sudo chmod 600 /mnt/persistent/etc/sops/age/keys.txt
   ```
6. `reboot`, log in as `rebiz` with the `changeme` initial password, then switch over to the real
   config:
   ```bash
   git clone https://github.com/rebizzz/nixos ~/opt/nixos-config
   cd ~/opt/nixos-config
   sudo nixos-rebuild switch --flake .#laptop
   ```

After that first `switch`, sops takes over the real password and this installer flake is done, the
system is now running the main flake like normal.

## Testing without installing

```bash
nix build ".#nixosConfigurations.laptop.config.system.build.toplevel" --show-trace
```

Confirms the disk layout and hardware config evaluate and build cleanly before you commit to
actually partitioning anything.
