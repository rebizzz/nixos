# System Modules

NixOS modules, one per file, each self-registering as `flake.modules.nixos.<name>` (the dendritic
pattern: `import-tree` picks up every `.nix` file under here automatically, no manual import list
to maintain). `<name>` is what hosts reference in their `modules = [ ... ]` list, and does not
always match the filename.

## Current Structure

```
system/
├── apps/         # small standalone tool configs (nano)
├── core/         # nix settings, users, secrets, boot, auto-upgrade, mostly shared
├── desktop/      # laptop-only: fonts, gaming, persistence, tools
├── hardware/     # audio/display/gpu/power/network tuning, per host class
└── services/     # networking, containers, media, security, mostly server-only
```

## Shared vs Host-Class-Specific

A handful of module names exist in **two variants**, one for `laptop` and one suffixed `-server`
for `nixos-server`, because the underlying config genuinely differs per host class. Merging them
into one module would mean fighting over the same options, e.g. `laptop`'s `auto-cpufreq` battery
profiles vs `nixos-server`'s static `ondemand` governor:

| Concern     | `laptop`                          | `nixos-server`                    |
| ----------- | ---------------------------------- | ----------------------------------- |
| Power       | `power` (hardware/power.nix)       | `power-server` (hardware/power-server.nix) |
| Services    | `services` (services/services.nix) | `services-server` (services/services-server.nix) |
| Persistence | `persistence` (desktop/persistence.nix) | `persistence-server` (services/persistence-server.nix) |

Everything else in `core/` (`nix`, `secrets`, `user`) is genuinely shared and pulled into both
hosts via `../hosts/base.nix`. Everything in `desktop/` and most of `hardware/` only makes sense on
`laptop`. Most of `services/` (`networking`, `containers`, `security`, `media`) only makes sense on
`nixos-server`, and several of them read `hostVars`, a specialArg that only `nixos-server` is given.

See [../hosts/README.md](../hosts/README.md) for how each host picks which modules to import.

## Adding a Module

Drop a new `.nix` file anywhere under here with `flake.modules.nixos.<name> = { ... }: { ... };`
and it's picked up automatically. If it's desktop-only, `laptop` will pull it in without any
further wiring (see the `excludedModules` list in `../hosts/laptop/default.nix`). If it's
server-only, add it to the explicit module list in `../hosts/nixos-server/default.nix`.
