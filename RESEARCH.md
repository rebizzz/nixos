# Research: patterns from the wider nixos-config ecosystem

Written against commit `d0a2fe0`. This repo already uses the "dendritic" flake-parts +
`import-tree` pattern (see `modules/README.md`), which is itself one of the more advanced
patterns in the ecosystem — most public configs are still hand-wired `imports = [...]` lists.
Comparison below is against how other well-known personal configs (Misterio77/nix-config,
hlissner/dotfiles, the broader dendritic-pattern cohort documented at
[mightyiam/dendritic](https://github.com/mightyiam/dendritic)) approach the same problems,
drawn from general familiarity with the genre rather than a fresh clone-and-diff in this
session (no live web/GitHub fetch was performed here — treat specifics as directional, not
verbatim-verified against current upstream state).

## Worth adopting

**1. A `just check-host <name>` / per-host CI-style eval gate.**
Right now `just lint` runs `nix flake check` for the whole flake, but there's no single command
that just evaluates one host's `system.build.toplevel` the way `nixos-installer/README.md`'s
"Testing without installing" section does manually. A one-line Justfile recipe
(`nix build ".#nixosConfigurations.{{host}}.config.system.build.toplevel" --show-trace`) would
give a fast per-host sanity check without needing to remember the flakeref by hand. Low risk,
genuinely useful, matches a pattern common in larger dendritic configs that build every host in
CI on every push.

**2. A repo-root `.editorconfig` / `treefmt.nix` instead of a bare `alejandra` Justfile recipe.**
Several mature configs use `treefmt-nix` (a flake-parts module) to run `alejandra` +
`deadnix` + `statix` as one `nix fmt`, integrated with `nix flake check` so CI and local
`just fmt`/`just lint` can't drift apart. This repo already depends on flake-parts, so wiring
in `treefmt-nix` would be a small, idiomatic addition — `modules/flake/flake-parts.nix` is the
natural home for it. Not urgent, but it's the single most common addition mature dendritic
configs make that this one hasn't.

**3. Documenting the "why two variants" pattern more prominently at the point of use.**
`modules/system/README.md` already explains the `power`/`power-server`,
`services`/`services-server`, `persistence`/`persistence-server` split well. Some larger configs
instead push the shared subset into a `*-base` module (e.g. `podman-base.nix` here already does
exactly this for `containers`/`containers`) and have both variants import it. Only the
persistence/power/services trio don't yet follow this, and — see below — that's arguably correct
here.

## Explicitly NOT worth adopting

**1. A generic `flake.lib` "helpers" namespace.**
Bigger configs often grow a `lib/` directory of custom helper functions (`mkHost`, `mkUser`,
etc.) as they scale to many hosts. This repo has exactly two hosts with genuinely different
disk layouts, network setups, and hardware — introducing a generic host-factory function now
would be premature abstraction for a problem this repo doesn't have. If a third host ever
appears, revisit; until then this would violate the repo's own stated preference for explicit,
diffable per-host `default.nix` files (see `modules/hosts/README.md`, "Neither host
auto-picks-up new modules").

**2. Merging the `-server` module variants into their base counterparts via `mkIf`/`mkMerge`.**
Tempting on first read (`persistence.nix` vs `persistence-server.nix` do look like they could
collapse into one parameterized module), but the actual preserved-path lists, journald tuning,
and power settings genuinely diverge host-to-host, not just by a toggle. Forcing them into one
option-gated module would make future edits riskier — a change meant for one host's option
tree could silently affect the other's evaluation if the `mkIf` conditions are ever wrong. The
repo's own `system/README.md` already argues this explicitly and correctly; this research
agrees and recommends leaving it as-is.

**3. Secrets-per-host directory splitting.**
Some configs split `secrets/laptop.yaml` / `secrets/server.yaml`. This repo deliberately keeps
one shared `secrets/secrets.yaml` (see `secrets/README.md`) since both hosts share a WiFi PSK
and NextDNS profile secret. Splitting would add files without removing any real coupling —
not worth it unless the secret sets actually diverge further.

**4. Disko partition-helper extraction.**
`modules/hosts/laptop/_disko.nix` and `modules/hosts/nixos-server/_disko.nix` both define a
near-identical 5-line `btrfsOpts`/`subvol` local helper. This looks like duplication, but disk
layout files are exactly the place where explicit repetition beats DRY: a shared helper module
would mean a single edit could silently change both hosts' partition tables, in a place where a
bad edit is unrecoverable data loss, not a rebuild-and-see-what-breaks mistake. Recommend
leaving this duplicated.

## Not implemented directly

No changes were made on this branch beyond this file — everything above is either a
recommendation for a future session (the `treefmt-nix`/Justfile items) or an explicit
recommendation to leave existing repo decisions alone. Given the scope of "research report,"
and that the concrete, low-risk fixes found during this pass (a module-signature style nit, two
stale doc references) were already handled on the `feat/nix-code-optimization` and
`feat/docs-beautify` branches respectively, there was nothing left in-scope for this branch to
apply directly without either duplicating that work or overstepping into speculative rewrites.
