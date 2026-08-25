{lib}: let
  inherit (lib.generators) mkLuaInline;
in rec {
  lua = mkLuaInline;
  dsp = call: mkLuaInline "hl.dsp.${call}";
  # guarded via hl_layoutmsg (see _extra.nix): scrolling-only, no-ops on other layouts
  layoutmsg = msg: mkLuaInline "function() hl_layoutmsg(\"${msg}\") end";
}
