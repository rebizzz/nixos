# Home Manager Modules

Home Manager configuration, `laptop` only, `nixos-server` has no user session. One module per
file, self-registering as `flake.modules.homeManager.<name>`, aggregated by `default.nix` into
`flake.modules.homeManager.default`, the one module `laptop/default.nix` hands to home-manager.

## Current Structure

```
home/
├── default.nix   # aggregates everything below into one module
├── apps/         # per-application configs (brave, discord, git, nano)
├── desktop/      # umbriel, noctalia, mime associations, gtk/qt theme
├── terminal/     # fish, foot
└── services/     # user-level services (sound effects)
```

## Adding a Module

Drop a new `.nix` file anywhere under here with `flake.modules.homeManager.<name> = { ... }: { ... };`
and add it to the `imports` list in `default.nix`, unlike the NixOS side, home-manager modules
aren't picked up by a per-host explicit list, `default.nix` here is the only place that matters.
