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
├── desktop/      # laptop-only: fonts, gaming, tools
├── hardware/     # audio/display/gpu/power/network tuning, per host class
└── services/     # networking, containers, media, security, persistence, mostly server-only
```

## Shared vs Host-Class-Specific

A handful of modules differ genuinely between `laptop` and `nixos-server` (e.g. `laptop`'s
`auto-cpufreq` battery profiles vs `nixos-server`'s static `powersave` governor), but rather than
existing as two separately-named modules, each one is a single module gated on
`config.myConfig.hostClass` (an enum option declared in `../hosts/base.nix`, set to `"desktop"` or
`"server"` by each host's `default.nix`):

| Concern     | File                          | Gated by `myConfig.hostClass` |
| ----------- | ------------------------------ | ------------------------------ |
| Power       | `hardware/power.nix`           | `"desktop"` / `"server"`       |
| Services    | `services/services.nix`        | `"desktop"` / `"server"`       |
| Persistence | `services/persistence.nix`     | `"desktop"` / `"server"`       |

Everything else in `core/` (`nix`, `secrets`, `user`) is genuinely shared and pulled into both
hosts via `../hosts/base.nix`. Everything in `desktop/` and most of `hardware/` only makes sense on
`laptop`. Most of `services/` (`networking`, `containers`, `security`, `media`) only makes sense on
`nixos-server`, and several of them read `hostVars`, a specialArg that only `nixos-server` is given.

See [../hosts/README.md](../hosts/README.md) for how each host picks which modules to import.

## Adding a Module

Drop a new `.nix` file anywhere under here with `flake.modules.nixos.<name> = { ... }: { ... };`
and it registers itself, no imports list to touch in this directory. It's not live on any host
until you add `inputs.self.modules.nixos.<name>` to that host's aggregator module
(`../hosts/laptop/profile.nix` and/or `../hosts/nixos-server/profile.nix`), whichever needs it. If
the module's behavior should differ per host class rather than being included/excluded outright,
gate it on `config.myConfig.hostClass` instead (see above) and add it to both aggregators.
