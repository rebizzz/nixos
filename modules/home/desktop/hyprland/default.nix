_: {
  flake.modules.homeManager.hyprland = {
    config,
    pkgs,
    lib,
    ...
  }: let
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
      ${pkgs.kitty}/bin/kitty --class hyprland-cheatsheet -e ${pkgs.bash}/bin/bash -c '${pkgs.coreutils}/bin/cat << "EOF" | ${pkgs.less}/bin/less -R
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

    options.desktop.hyprland.extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Extra configuration lines for Hyprland";
    };

    config = {
      xdg.configFile."hypr/hyprland.conf".text = config.desktop.hyprland.extraConfig;

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
