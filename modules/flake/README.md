# Flake Wiring

The small amount of glue that isn't a NixOS or home-manager module: how the flake builds itself.

## `flake-parts.nix`

Declares `systems = ["x86_64-linux"]` (required for `perSystem` to produce anything at all) and
the dev shell: `sops`, `age`, `just`. Loaded automatically by `direnv` on `cd`, see the repo root
[README](../../README.md).

## `checks.nix`

Defines `checks.laptop-boots`, a NixOS VM test that boots a minimal machine importing the `user`
module and asserts it reaches `multi-user.target` with the `rebiz` user correctly in the `wheel`
group. It intentionally excludes hardware/disko/desktop modules (those depend on real device paths
and GPU/Wayland state a VM can't provide) and the `nix` module (its `nixpkgs.config` setting
conflicts with the test harness's own read-only nixpkgs config), so this only catches
activation-time breakage in user/account plumbing, not hardware-specific or GUI issues. `nix flake
check --no-build` does not build it; CI builds it explicitly (`nix build
.#checks.x86_64-linux.laptop-boots`) since it's too heavy to run on every local `nix flake check`.
