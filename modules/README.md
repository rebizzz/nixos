# Modules

Everything that builds the two systems lives here, organized by what it configures rather than
by host. See the flake root [README](../README.md) for the big picture.

## Current Structure

```
modules/
├── flake/    # flake-parts wiring: devShell, colmena hive, systems list
├── hosts/    # one directory per machine, see hosts/README.md
├── system/   # NixOS modules, one per file, see system/README.md
└── home/     # Home Manager modules, laptop only, see home/README.md
```

## How It Fits Together

`flake.nix` itself is nearly empty, just inputs plus `import-tree ./modules`. Every `.nix` file
under here registers itself as `flake.modules.nixos.<name>` or `flake.modules.homeManager.<name>`
(the dendritic pattern), except files under `hosts/`, which assemble those registered modules into
actual `nixosConfigurations` and the colmena hive.

Files prefixed with `_` (`_host.nix`, `_disko.nix`, `_hardware.nix`) are plain data, not
flake-parts modules, `import-tree` skips them and each host imports them by path instead.
