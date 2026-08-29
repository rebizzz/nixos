{lib, ...}: let
  mainMod = "SUPER";

  workspaceBinds = builtins.concatLists (builtins.genList (i:
    let
      ws = toString (i + 1);
    in [
      "${mainMod}, ${ws}, workspace, ${ws}"
      "${mainMod} CTRL, ${ws}, movetoworkspace, ${ws}"
      "${mainMod} CTRL SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
    ]
  ) 9);
in {
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = mainMod;

    bind = [
      # Apps / launcher
      "$mainMod, Return, exec, kitty"
      "$mainMod, D, exec, noctalia msg panel-toggle launcher"
      "$mainMod, B, exec, brave-origin --new-window"
      "$mainMod, E, exec, thunar"
      ", XF86Calculator, exec, noctalia msg panel-toggle yuuto/calculator:panel"

      # Session / misc
      "$mainMod, Q, killactive"
      "$mainMod ALT, L, exec, noctalia msg session lock"
      "$mainMod SHIFT, Q, exec, noctalia msg panel-toggle session"
      "$mainMod, Slash, exec, hyprland-cheatsheet"
      "$mainMod SHIFT, Slash, exec, hyprland-cheatsheet"
      "CTRL ALT, Delete, exit"

      # Window state
      "$mainMod, T, togglefloating"
      "$mainMod, F, fullscreen, 0"
      "$mainMod, M, fullscreen, 1"
      "$mainMod, C, centerwindow"
      "$mainMod SHIFT, C, layoutmsg, fit_into_view"
      "$mainMod, R, layoutmsg, colresize +conf"
      "$mainMod, comma, layoutmsg, swapcol l"
      "$mainMod, period, layoutmsg, swapcol r"
      "$mainMod, minus, layoutmsg, colresize -0.1"
      "$mainMod, equal, layoutmsg, colresize +0.1"

      # Window Grouping & Tabs
      "$mainMod, W, togglegroup"
      "$mainMod SHIFT, W, lockactivegroup, toggle"
      "$mainMod ALT, J, changegroupactive, f"
      "$mainMod ALT, K, changegroupactive, b"
      "$mainMod ALT, L, changegroupactive, f"
      "$mainMod ALT, H, changegroupactive, b"
      "$mainMod CTRL, H, moveintogroup, l"
      "$mainMod CTRL, L, moveintogroup, r"
      "$mainMod CTRL, K, moveintogroup, u"
      "$mainMod CTRL, J, moveintogroup, d"
      "$mainMod CTRL, E, moveoutofgroup"

      # Focus / move
      "$mainMod, H, movefocus, l"
      "$mainMod, L, movefocus, r"
      "$mainMod, J, movefocus, d"
      "$mainMod, K, movefocus, u"
      "$mainMod SHIFT, H, movewindow, l"
      "$mainMod SHIFT, L, movewindow, r"
      "$mainMod SHIFT, J, movewindow, d"
      "$mainMod SHIFT, K, movewindow, u"
      "$mainMod CTRL, Down, workspace, m+1"
      "$mainMod CTRL, Up, workspace, m-1"

      # Layout & Overview
      "$mainMod, Tab, exec, cycle-layout"
      "$mainMod, O, exec, noctalia msg panel-toggle overview"

      # Outputs / Monitors
      "$mainMod SHIFT, Left, focusmonitor, l"
      "$mainMod SHIFT, Right, focusmonitor, r"
      "$mainMod SHIFT, Up, focusmonitor, u"
      "$mainMod SHIFT, Down, focusmonitor, d"
      "$mainMod CTRL SHIFT, Left, movewindow, mon:l"
      "$mainMod CTRL SHIFT, Right, movewindow, mon:r"
      "$mainMod CTRL SHIFT, Up, movewindow, mon:u"
      "$mainMod CTRL SHIFT, Down, movewindow, mon:d"

      # Manual Scratchpad (custom user windows)
      "$mainMod SHIFT, Space, movetoworkspacesilent, special:scratchpad"
      "$mainMod, Space, togglespecialworkspace, scratchpad"
      "$mainMod, Grave, togglespecialworkspace, scratchpad"

      # Dedicated Discord and Brave Scratchpads
      "$mainMod CTRL, D, exec, toggle-scratchpad discord discord"
      "$mainMod CTRL, B, exec, toggle-scratchpad brave brave-origin"
      "$mainMod SHIFT, D, movetoworkspacesilent, special:discord"
      "$mainMod SHIFT, B, movetoworkspacesilent, special:brave"

      # Cursor Magnifier / Zoom
      "$mainMod, Z, exec, hyprctl keyword cursor:zoom_factor 1.5"
      "$mainMod SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1.0"
      "$mainMod CTRL, equal, exec, hyprctl keyword cursor:zoom_factor 2.0"
      "$mainMod CTRL, minus, exec, hyprctl keyword cursor:zoom_factor 1.0"

      # Screenshots
      ", Print, exec, noctalia msg screenshot-region"
      "CTRL, Print, exec, noctalia msg screenshot-fullscreen"
      "SHIFT, Print, exec, noctalia msg screenshot-area"

      # Media / Volume / Brightness
      ", XF86AudioRaiseVolume, exec, noctalia msg volume-up"
      ", XF86AudioLowerVolume, exec, noctalia msg volume-down"
      ", XF86AudioMute, exec, noctalia msg volume-mute"
      ", XF86AudioMicMute, exec, noctalia msg mic-mute"
      ", XF86AudioNext, exec, noctalia msg media next"
      ", XF86AudioPrev, exec, noctalia msg media previous"
      ", XF86AudioPlay, exec, noctalia msg media toggle"
      ", XF86AudioPause, exec, noctalia msg media toggle"
      ", XF86MonBrightnessUp, exec, noctalia msg brightness-up"
      ", XF86MonBrightnessDown, exec, noctalia msg brightness-down"

      # Scroll wheel focus / workspace move
      "$mainMod, mouse_up, movefocus, l"
      "$mainMod, mouse_down, movefocus, r"
      "$mainMod SHIFT, mouse_up, movewindow, l"
      "$mainMod SHIFT, mouse_down, movewindow, r"
      "$mainMod CTRL, mouse_up, workspace, m-1"
      "$mainMod CTRL, mouse_down, workspace, m+1"
    ] ++ workspaceBinds;

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
  };
}
