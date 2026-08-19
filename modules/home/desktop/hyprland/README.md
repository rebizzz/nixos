# hyprland

A native Nix port of caelestia's default Hyprland config
(github:caelestia-dots/caelestia, `hypr/`). The original is Lua, hand-authored
per file using `hl.on`/`require`. This is plain Nix attrsets instead, via
home-manager's `wayland.windowManager.hyprland.settings` (which renders to
Lua under the hood since Hyprland deprecated hyprlang in favor of Lua as of
0.55).

## Files

- `default.nix` - entry point, packages, enable flags
- `_settings.nix` - general/input/decoration/animations/gestures/group/misc,
  monitor default, curves, animations, gestures, env vars
- `_rules.nix` - window/workspace/layer rules
- `_binds.nix` - plain keybinds (dispatcher calls only)
- `_exec.nix` - startup hook (ported from execs.lua)
- `_extra.nix` - the only real Lua logic: percentage-based resize, PiP
  handling, and the special-workspace app launcher. Can't be plain Nix
  since these need actual functions, not just data.
- `_lib.nix` - shared vars/helpers used by the files above

Files starting with `_` are plain Nix, not flake modules. They opt out of
this repo's import-tree auto-discovery (same convention as `_disko.nix`).

## Changed from caelestia's defaults

- Terminal/browser/file manager/editor point at apps already set up
  elsewhere in this config (ghostty/brave-origin/nautilus/nano) instead of
  caelestia's own defaults (foot/firefox/thunar/codium).
- Cursor theme is `Bibata-Modern-Classic` (matches the old niri setup)
  instead of caelestia's `sweet-cursors`.
- Colour scheme is a static snapshot of caelestia's defaults. The real
  caelestia dots regenerate this live from your wallpaper; that mechanism
  is Lua-runtime-specific and isn't wired up here, so Hyprland's
  border/group colours stay fixed until hand-edited in `_lib.nix`.
- Workspace groups (a second set of 10 workspaces via Ctrl+Super) dropped
  entirely, by request. Workspace switching is single-tier now.
- Bumped `Super+Alt+F12` test-notification bind, not useful outside dev.
- Some redundant alternate key combos for the same action got collapsed to
  one binding (e.g. resize used to have both a direct key and an Alt+arrow
  variant, now just the direct key).
- `general:layout` cycling (Super+Tab: dwindle -> master -> scrolling) is
  new, not a caelestia default. Untested against Hyprland's very new Lua
  config runtime; if it misbehaves, run
  `hyprctl keyword general:layout <name>` by hand instead.

## Known gaps

- geoclue's demo agent (for nightlight location) is replaced with
  `services.geoclue2.enable` at the system level, the NixOS-native
  equivalent, since caelestia's exec launches a binary from an Arch-only
  path that doesn't exist on NixOS.
- `caelestia clipboard`/`caelestia emoji` binds assume the caelestia shell
  UI is running to handle them.
- Never tested live. Build succeeds and the generated Lua passes `luac -p`,
  but that only proves syntax, not runtime behaviour.

## Keybinds

### Apps

| Bind | Action |
|---|---|
| Super+T | Terminal |
| Super+W | Browser |
| Super+C | Editor (ghostty + nano) |
| Super+E | File explorer |
| Ctrl+Alt+V | Audio settings |

### Windows

| Bind | Action |
|---|---|
| Super+Q | Close window |
| Super+Alt+Space | Toggle floating |
| Super+F | Fullscreen |
| Super+Alt+F | Fullscreen (maximized/bordered) |
| Super+P | Pin window |
| Ctrl+Super+\\ | Center window |
| Ctrl+Super+Alt+\\ | Normalize (55%x70%, centered) |
| Super+Alt+\\ | Toggle picture-in-picture |
| Super+Z / Super+LMB | Move window (drag) |
| Super+X / Super+RMB | Resize window (drag) |
| Super+Minus/Equal | Resize width -10%/+10% |
| Super+Shift+Minus/Equal | Resize height -10%/+10% |
| Super+arrows | Focus direction |
| Super+Shift+arrows | Move window direction |
| Super+Tab | Cycle layout: dwindle -> master -> scrolling |

### Groups (tabs)

| Bind | Action |
|---|---|
| Super+Comma | Toggle group |
| Super+Shift+Comma | Lock active group |
| Super+U | Move window out of group |
| Alt+Tab / Shift+Alt+Tab | Cycle windows in group |
| Ctrl+Alt+Tab / Ctrl+Shift+Alt+Tab | Cycle groups |

### Workspaces

| Bind | Action |
|---|---|
| Super+1-9,0 | Focus workspace 1-10 |
| Super+Alt+1-9,0 | Move window to workspace 1-10 |
| Super+scroll / PageUp/PageDown | Focus prev/next workspace |
| Super+Alt+scroll | Move window to prev/next workspace |
| Super+Alt+S | Move window to special workspace |
| Ctrl+Super+Shift+Down | Move window out of special workspace |

### Special workspaces (app launcher)

| Bind | Action |
|---|---|
| Super+S | Toggle last special workspace |
| Super+M | Music (Spotify/Feishin) |
| Super+D | Communication (Discord/WhatsApp) |
| Super+R | Todo (Todoist) |
| Ctrl+Shift+Escape | System monitor (btop) |

### Utilities

| Bind | Action |
|---|---|
| Print | Screenshot |
| Super+Shift+S | Screenshot (freeze) |
| Super+Shift+Alt+S | Screenshot (region) |
| Ctrl+Alt+R | Record |
| Super+Alt+R | Record (sound) |
| Super+Shift+Alt+R | Record (region) |
| Super+Shift+C | Colour picker |
| Super+V | Clipboard history |
| Super+Alt+V | Clipboard history (delete mode) |
| Super+Period | Emoji picker |
| Ctrl+Shift+Alt+V | Paste latest clipboard item (ydotool) |

### Media / brightness / volume

| Bind | Action |
|---|---|
| XF86MonBrightnessUp/Down | Brightness |
| Ctrl+Super+Space / XF86AudioPlay/Pause | Play/pause |
| Ctrl+Super+Equal / XF86AudioNext | Next track |
| Ctrl+Super+Minus / XF86AudioPrev | Previous track |
| Ctrl+Super+Backspace / XF86AudioStop | Stop |
| Super+Shift+M / XF86AudioMute | Toggle mute |
| XF86AudioMicMute | Toggle mic mute |
| XF86AudioRaiseVolume/LowerVolume | Volume +/-10% |

### Misc

| Bind | Action |
|---|---|
| Super+Super_L | Launcher |
| Ctrl+Alt+Delete | Session menu |
| Super+N | Sidebar |
| Ctrl+Alt+C | Clear notifications |
| Super+K | Show all panels |
| Super+L | Lock |
| Super+Alt+L | Restore lock (after crash) |
| Super+Shift+L | Suspend then hibernate |
| Ctrl+Super+Shift+R | Kill shell |
| Ctrl+Super+Alt+R | Restart shell |
