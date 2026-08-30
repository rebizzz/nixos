_: {
  flake.modules.homeManager.hyprland = {
    config,
    pkgs,
    lib,
    ...
  }: let
    # ---------------------------------------------------------------------------
    # Helper scripts
    # ---------------------------------------------------------------------------
    cycle-layout = pkgs.writeShellScriptBin "cycle-layout" ''
      LAYOUTS=("scrolling" "dwindle" "master" "monocle")
      STATE_FILE="/tmp/hypr_active_layout"
      if [ ! -f "$STATE_FILE" ]; then
        echo "scrolling" > "$STATE_FILE"
      fi
      CURRENT=$(cat "$STATE_FILE")
      NEXT=""
      for i in "''${!LAYOUTS[@]}"; do
        if [ "''${LAYOUTS[$i]}" = "$CURRENT" ]; then
          NEXT_INDEX=$(( (i + 1) % ''${#LAYOUTS[@]} ))
          NEXT="''${LAYOUTS[$NEXT_INDEX]}"
          break
        fi
      done
      if [ -z "$NEXT" ]; then
        NEXT="scrolling"
      fi
      echo "$NEXT" > "$STATE_FILE"

      if [ "$NEXT" = "monocle" ]; then
        ${pkgs.hyprland}/bin/hyprctl keyword general:layout "dwindle"
        ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen 1
        ${pkgs.libnotify}/bin/notify-send -u low -t 1500 -a "Hyprland" "Layout Switched" "Mode: Monocle (Fullscreen)"
      else
        ${pkgs.hyprland}/bin/hyprctl dispatch fullscreen 0
        ${pkgs.hyprland}/bin/hyprctl keyword general:layout "$NEXT"
        ${pkgs.libnotify}/bin/notify-send -u low -t 1500 -a "Hyprland" "Layout Switched" "Mode: ''${NEXT^}"
      fi
    '';

    toggle-scratchpad = pkgs.writeShellScriptBin "toggle-scratchpad" ''
      NAME="$1"
      LAUNCH_CMD="$2"
      WORKSPACE="special:$NAME"

      HAS_WINDOWS=$(${pkgs.hyprland}/bin/hyprctl clients -j | ${pkgs.jq}/bin/jq -r ".[] | select(.workspace.name == \"$WORKSPACE\") | .address" | head -n 1)

      if [ -z "$HAS_WINDOWS" ]; then
        if [ -n "$LAUNCH_CMD" ]; then
          ${pkgs.hyprland}/bin/hyprctl dispatch exec "[workspace $WORKSPACE silent] $LAUNCH_CMD"
          sleep 0.3
        fi
      fi

      ${pkgs.hyprland}/bin/hyprctl dispatch togglespecialworkspace "$NAME"
    '';

    hyprland-cheatsheet = pkgs.writeShellScriptBin "hyprland-cheatsheet" ''
      ${pkgs.kitty}/bin/kitty --class hyprland-cheatsheet -e ${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat <<"EOF" | ${pkgs.less}/bin/less -R
================================================================================
                    HYPRLAND KEYBINDINGS CHEATSHEET
================================================================================

[ SYSTEM & LAUNCHER ]
  Super + Return             Open Terminal (Kitty)
  Super + D                  App Launcher (Noctalia)
  Super + B                  Web Browser (Brave)
  Super + E                  File Manager (Thunar)
  Super + Q                  Close / Kill Active Window
  Super + Alt + L            Lock Screen (Noctalia)
  Super + Shift + Q          Session / Power Menu
  Super + /                  Open this Cheatsheet
  Ctrl + Alt + Delete        Exit Hyprland Session

[ WINDOW STATES & LAYOUTS ]
  Super + T                  Toggle Floating
  Super + F                  Toggle Fullscreen
  Super + M                  Toggle Maximize (Monocle)
  Super + C                  Center Floating Window
  Super + Tab                Cycle Layouts (Scrolling -> Dwindle -> Master -> Monocle)
  Super + R                  Cycle Column Width Preset (Scrolling)
  Super + Shift + C          Fit Column Into View (Scrolling)
  Super + , / .              Swap Column Left / Right (Scrolling)
  Super + - / =              Shrink / Expand Column Width (Scrolling)

[ WINDOW GROUPING & TABS ]
  Super + W                  Toggle Group (Tabbed Window Container)
  Super + Shift + W          Lock / Unlock Group
  Super + Alt + J / L        Next Tab in Group
  Super + Alt + K / H        Previous Tab in Group
  Super + Ctrl + H/J/K/L     Move Window into Adjacent Group
  Super + Ctrl + E           Eject Window from Group

[ NAVIGATION & WORKSPACES ]
  Super + H / J / K / L      Focus Left / Down / Up / Right
  Super + Shift + H/J/K/L    Move Window Left / Down / Up / Right
  Super + [1-9]              Switch to Workspace 1..9
  Super + Ctrl + [1-9]       Move Window to Workspace 1..9
  Super + Ctrl + Shift + [1-9] Move Window Silently to Workspace 1..9
  Super + Ctrl + Down / Up   Next / Previous Workspace (Vertical)
  Super + O                  Toggle Workspace Overview

[ SCRATCHPADS & TOOLS ]
  Super + Space (or `)       Toggle General Scratchpad
  Super + Shift + Space      Send Focused Window to General Scratchpad
  Super + Ctrl + D           Toggle Discord Scratchpad (Auto-launches)
  Super + Ctrl + B           Toggle Brave Scratchpad (Auto-launches)
  Super + Z / Shift + Z      Zoom In (1.5x) / Reset Zoom (1.0x)
  Print                      Region Screenshot (Noctalia)
  Ctrl + Print               Fullscreen Screenshot
  Shift + Print              Annotated Screenshot (Satty)

================================================================================
EOF
'
    '';

    # ---------------------------------------------------------------------------
    # Nix → Hyprland Lua serializer
    #
    # Converts the merged desktop.hyprland.settings attrset into a valid
    # hyprland.lua file. Handles all types Hyprland Lua accepts.
    # ---------------------------------------------------------------------------
    toLuaValue = v:
      if builtins.isBool v
      then (if v then "true" else "false")
      else if builtins.isInt v || builtins.isFloat v
      then builtins.toString v
      else if builtins.isString v
      then ''"${lib.escape [''"'' "\\"] v}"''
      else if builtins.isList v
      then "{ ${lib.concatMapStringsSep ", " toLuaValue v} }"
      else if builtins.isAttrs v
      then let
        pairs = lib.mapAttrsToList (k: val: "${toLuaKey k} = ${toLuaValue val}") v;
      in "{\n    ${lib.concatStringsSep ",\n    " pairs},\n  }"
      else builtins.toString v;

    # Keys with dots OR hyphens need bracket notation in Lua
    toLuaKey = k:
      if builtins.match ".*[\\.-].*" k != null
      then ''["${k}"]''
      else k;

    # Emit repeated directive lines for list values (bind, monitor, windowrule…)
    mkRepeatDirectives = section: key: values:
      lib.concatMapStringsSep "\n" (v: "${section}.${key}(${toLuaValue v})") values;

    # Sections that are emitted as repeated function calls rather than table assignments
    repeatSections = ["bind" "bindm" "binde" "bindr" "bindl" "monitor" "windowrule" "layerrule" "workspace" "exec-once" "exec" "env" "gesture" "animation" "bezier"];

    isRepeat = key: builtins.elem key repeatSections;

    # Emit one top-level key from the settings attrset
    mkLuaSection = key: value: let
      luaKey = toLuaKey key;
    in
      if isRepeat key
      then
        # Lists of strings → repeated hl.keyword("value") calls
        lib.concatMapStringsSep "\n" (v:
          if builtins.isString v
          then "hl.${key}(${toLuaValue v})"
          else "hl.${key}(${toLuaValue v})"
        ) (if builtins.isList value then value else [value])
      else if builtins.isAttrs value
      then let
        pairs = lib.mapAttrsToList (k: v: "  ${toLuaKey k} = ${toLuaValue v},") value;
      in ''
        hl.config.${luaKey}({
        ${lib.concatStringsSep "\n" pairs}
        })''
      else "hl.config.${luaKey} = ${toLuaValue value}";

    # Build the full hyprland.lua text from the merged settings attrset
    hyprlandLua = let
      settings = config.desktop.hyprland.settings;
      sections = lib.mapAttrsToList mkLuaSection settings;
    in ''
      -- hyprland.lua – generated by Nix. Do not edit manually.
      local hl = require("hyprland")

      ${lib.concatStringsSep "\n\n" sections}

      ${config.desktop.hyprland.extraLua}
    '';

  in {
    imports = [
      ./_general.nix
      ./_appearance.nix
      ./_animation.nix
      ./_input.nix
      ./_layout.nix
      ./_output.nix
      ./_rules.nix
      ./_binds.nix
      ./_misc.nix
    ];

    # -------------------------------------------------------------------------
    # Module options – typed Nix settings each sub-module populates
    # -------------------------------------------------------------------------
    options.desktop.hyprland = {
      settings = lib.mkOption {
        type = lib.types.attrsOf lib.types.anything;
        default = {};
        description = "Hyprland settings. Serialized to hyprland.lua by the parent module.";
      };

      extraLua = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Raw Lua appended verbatim after the generated config (use sparingly).";
      };
    };

    config = {
      # Write the generated Lua config – this is the ONLY place we touch XDG
      xdg.configFile."hypr/hyprland.lua".text = hyprlandLua;

      home.packages = [
        cycle-layout
        toggle-scratchpad
        hyprland-cheatsheet
        pkgs.jq
        pkgs.libnotify
      ];
    };
  };
}
