# System Modules

NixOS modules, one per file, each self-registering as `flake.modules.nixos.<name>` (the dendritic
pattern: `import-tree` picks up every `.nix` file under here automatically, no manual import list
to maintain). `<name>` is what hosts reference in their `modules = [ ... ]` list, and does not
always match the filename.

## Current Structure

```
system/
├── core/         # nix settings, users, secrets, boot — shared
├── desktop/      # fonts, gaming, tools, browser policy
├── hardware/     # audio/display/gpu/power tuning
└── services/     # containers, networking, persistence
```

## Adding a Module

Drop a new `.nix` file anywhere under here with `flake.modules.nixos.<name> = { ... }: { ... };`
and it registers itself, no imports list to touch in this directory. It's not live on the host
until you add `inputs.self.modules.nixos.<name>` to `../hosts/laptop/profile.nix`.
