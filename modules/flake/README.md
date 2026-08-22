# Flake Wiring

The small amount of glue that isn't a NixOS or home-manager module: how the flake builds itself.

## `flake-parts.nix`

Declares `systems = ["x86_64-linux"]` (required for `perSystem` to produce anything at all) and
the dev shell: `deploy-rs`, `sops`, `age`, `nixos-anywhere`, `just`. Loaded automatically by
`direnv` on `cd`, see the repo root [README](../../README.md).

The dev shell's `deploy-rs` package is taken from the nixpkgs binary cache rather than built from
the `deploy-rs` flake: `deployPkgs` overlays nixpkgs with `deploy-rs.overlays.default`, then
swaps the CLI derivation for nixpkgs' own `pkgs.deploy-rs` while keeping the flake's `lib`
(`activate.nixos` etc.). The `deploy.nodes` attrset itself lives with `nixos-server` (in
`modules/hosts/nixos-server/default.nix`), not here, `flake.deploy` is an undeclared flake-parts
output, so only one file is allowed to define it, splitting it across files throws "defined
multiple times".
