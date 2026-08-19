# Flake Wiring

The small amount of glue that isn't a NixOS or home-manager module: how the flake builds itself.

## `flake-parts.nix`

Declares `systems = ["x86_64-linux"]` (required for `perSystem` to produce anything at all) and
the dev shell: `colmena`, `sops`, `age`, `nixos-anywhere`, `just`. Loaded automatically by `direnv`
on `cd`, see the repo root [README](../../README.md).

## `colmena.nix`

```nix
flake.colmenaHive = inputs.colmena.lib.makeHive inputs.self.colmena;
```

Wraps the hive attrset defined in `flake.colmena` (in `modules/hosts/nixos-server/default.nix`)
into the `colmenaHive` output colmena's CLI actually reads. The hive definition itself lives with
`nixos-server`, not here, `flake.colmena` is an undeclared flake-parts output, so only one file is
allowed to define it, splitting it across files throws "defined multiple times".
