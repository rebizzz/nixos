{lib}: let
  inherit (lib.generators) mkLuaInline;
in rec {
  lua = mkLuaInline;
  dsp = call: mkLuaInline "hl.dsp.${call}";

  terminal = "ghostty";
  browser = "brave-origin";
  fileExplorer = "nautilus";
  audioSettings = "pavucontrol";
  # codium isn't installed, use nano in a terminal instead
  editor = "ghostty -e nano";

  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = "24";
  sleepGestureCmd = "systemctl suspend-then-hibernate";

  # Static snapshot of caelestia's default colour scheme, not wallpaper-reactive
  scheme = {
    primary = "c2c1ff";
    onPrimary = "2a2a60";
    outline = "918f9a";
    secondary = "c6c4e0";
    surfaceContainer = "201f23";
    inversePrimary = "595992";
  };

  activeBorder = "rgba(${scheme.primary}e6)";
  inactiveBorder = "rgba(${scheme.outline}11)";

  directions = ["left" "right" "up" "down"];

  # tag every window matching field=pattern, definition applied separately
  taggedRule = tag: field: patterns:
    map (p: {_args = [{match.${field} = p;} "+${tag}"];}) patterns;

  # same, but for a full match table instead of one field
  taggedRuleRaw = tag: matches:
    map (m: {_args = [{match = m;} "+${tag}"];}) matches;
}
