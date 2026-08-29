{inputs, ...}: {
  flake.modules.homeManager.hyprland = {
    pkgs,
    ...
  }: let
    cycle-layout = pkgs.writeShellScriptBin "cycle-layout" ''
      LAYOUTS=(scrolling dwindle master monocle)

      INFO=$(hyprctl activeworkspace -j)

      LAYOUT=$(printf '%s' "$INFO" | jq -r '.tiledLayout // empty')
      WORKSPACE_ID=$(printf '%s' "$INFO" | jq -r '.id')
      WORKSPACE_NAME=$(printf '%s' "$INFO" | jq -r '.name')

      CURRENT=0
      for i in "''${!LAYOUTS[@]}"; do
        if [ "''${LAYOUTS[i]}" = "$LAYOUT" ]; then
          CURRENT=$i
          break
        fi
      done

      if [[ "$1" == "--prev" ]]; then
        TARGET=$(( (CURRENT - 1 + ''${#LAYOUTS[@]}) % ''${#LAYOUTS[@]} ))
      else
        TARGET=$(( (CURRENT + 1) % ''${#LAYOUTS[@]} ))
      fi

      NEXT_LAYOUT="''${LAYOUTS[$TARGET]}"
      hyprctl keyword general:layout "$NEXT_LAYOUT" > /dev/null

      notify-send --icon state-information \
                  --app-name cycle-layout \
                  -h "string:x-canonical-private-synchronous:cycle-layout" \
                  "Layout changed" "Current layout: $NEXT_LAYOUT (workspace $WORKSPACE_NAME)"
    '';

    toggle-scratchpad = pkgs.writeShellScriptBin "toggle-scratchpad" ''
      NAME="''${1:-scratchpad}"
      CMD="''${2:-}"

      if [ -n "$CMD" ]; then
        CLIENTS=$(hyprctl clients -j | jq -r --arg ws "special:$NAME" '.[] | select(.workspace.name == $ws) | .address')
        if [ -z "$CLIENTS" ]; then
          ANY_CLIENT=$(hyprctl clients -j | jq -r --arg cls "$NAME" '.[] | select(.class | test($cls; "i")) | .address' | head -n 1)
          if [ -n "$ANY_CLIENT" ]; then
            hyprctl dispatch movetoworkspacesilent "special:$NAME,address:$ANY_CLIENT"
          else
            hyprctl dispatch exec "[workspace special:$NAME silent] $CMD"
          fi
        fi
      fi

      hyprctl dispatch togglespecialworkspace "$NAME"
    '';

    hyprland-cheatsheet = pkgs.writeShellScriptBin "hyprland-cheatsheet" ''
      cat << 'EOF' | ${pkgs.kitty}/bin/kitty --class hyprland-cheatsheet -o initial_window_width=920 -o initial_window_height=680 -o font_size=11 sh -c "cat; read -n 1"
================================================================================
                         HYPRLAND KEYBINDINGS CHEATSHEET
================================================================================

  APPS & LAUNCHERS
    Super + Return              Open Terminal (Kitty)
    Super + D                   App Launcher (Noctalia)
    Super + B                   Brave Browser
    Super + E                   File Manager (Thunar)
    Super + /                   This Cheatsheet
    XF86Calculator              Calculator Panel

  LAYOUT & WORKSPACES
    Super + Tab                 Cycle Layout (Scrolling -> Dwindle -> Master -> Monocle)
    Super + O                   Noctalia Overview / Panel
    Super + 1..9                Switch to Workspace 1..9
    Super + Ctrl + 1..9         Move Window to Workspace 1..9
    Super + Ctrl + Shift + 1..9 Move Window to Workspace Silently
    Super + Ctrl + Down/Up      Next / Previous Workspace

  WINDOW MANAGEMENT & SCROLLING
    Super + Q                   Close Window
    Super + T                   Toggle Floating
    Super + F                   Fullscreen
    Super + M                   Maximize
    Super + C                   Center Window
    Super + Shift + C           Fit Column into View
    Super + R                   Cycle Column Width (0.25 -> 0.33 -> 0.5 -> 0.67 -> 0.75 -> 1.0)
    Super + , / .               Swap Column Left / Right
    Super + - / =               Shrink / Expand Column Width

  NAVIGATION & FOCUS
    Super + H / J / K / L       Focus Left / Down / Up / Right
    Super + Shift + H/J/K/L     Move Window Left / Down / Up / Right

  WINDOW GROUPING & TABS
    Super + W                   Toggle Group (Tabbed Container)
    Super + Shift + W           Lock / Unlock Group
    Super + Alt + J / L         Next Tab in Group
    Super + Alt + K / H         Previous Tab in Group
    Super + Ctrl + H/J/K/L      Move Window into Group (Left/Down/Up/Right)
    Super + Ctrl + E            Eject Window out of Group

  SCRATCHPADS (SPECIAL WORKSPACES)
    Super + Space               Toggle Scratchpad (Manual)
    Super + Shift + Space       Send Window to Scratchpad
    Super + `                   Toggle Scratchpad
    Super + Ctrl + D            Toggle Discord Scratchpad
    Super + Ctrl + B            Toggle Brave Scratchpad
    Super + Shift + D / B       Send Window to Discord / Brave Scratchpad

  SCREEN ZOOM & MAGNIFIER
    Super + Z                   Zoom In (1.5x)
    Super + Shift + Z           Reset Zoom (1.0x)
    Super + Ctrl + = / -        Zoom In (2.0x) / Reset Zoom

  SCREENSHOTS & SYSTEM
    Print                       Screenshot Region
    Ctrl + Print                Screenshot Fullscreen
    Shift + Print               Screenshot Window / Area
    Super + Alt + L             Lock Screen
    Super + Shift + Q           Session / Power Menu
    Ctrl + Alt + Delete         Quit Hyprland Session

================================================================================
                   Press any key or close window to exit
================================================================================
EOF
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
    ];

    wayland.windowManager.hyprland = {
      enable = true;
    };

    home.packages = [
      cycle-layout
      toggle-scratchpad
      hyprland-cheatsheet
      pkgs.jq
      pkgs.libnotify
    ];
  };
}
