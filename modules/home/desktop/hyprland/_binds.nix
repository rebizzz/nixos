_: let
  mainMod = "SUPER";

  workspaceBinds = builtins.concatStringsSep "\n" (builtins.genList (i:
    let
      ws = toString (i + 1);
    in ''
      bind = ${mainMod}, ${ws}, workspace, ${ws}
      bind = ${mainMod} CTRL, ${ws}, movetoworkspace, ${ws}
      bind = ${mainMod} CTRL SHIFT, ${ws}, movetoworkspacesilent, ${ws}
    ''
  ) 9);
in {
  desktop.hyprland.extraConfig = ''
    # Apps / launcher
    bind = ${mainMod}, Return, exec, kitty
    bind = ${mainMod}, D, exec, noctalia msg panel-toggle launcher
    bind = ${mainMod}, B, exec, brave-origin --new-window
    bind = ${mainMod}, E, exec, thunar
    bind = , XF86Calculator, exec, noctalia msg panel-toggle yuuto/calculator:panel

    # Session / misc
    bind = ${mainMod}, Q, killactive
    bind = ${mainMod} ALT, L, exec, noctalia msg session lock
    bind = ${mainMod} SHIFT, Q, exec, noctalia msg panel-toggle session
    bind = ${mainMod}, Slash, exec, hyprland-cheatsheet
    bind = ${mainMod} SHIFT, Slash, exec, hyprland-cheatsheet
    bind = CTRL ALT, Delete, exit

    # Window state
    bind = ${mainMod}, T, togglefloating
    bind = ${mainMod}, F, fullscreen, 0
    bind = ${mainMod}, M, fullscreen, 1
    bind = ${mainMod}, C, centerwindow
    bind = ${mainMod} SHIFT, C, layoutmsg, fit_into_view
    bind = ${mainMod}, R, layoutmsg, colresize +conf
    bind = ${mainMod}, comma, layoutmsg, swapcol l
    bind = ${mainMod}, period, layoutmsg, swapcol r
    bind = ${mainMod}, minus, layoutmsg, colresize -0.1
    bind = ${mainMod}, equal, layoutmsg, colresize +0.1

    # Window Grouping & Tabs
    bind = ${mainMod}, W, togglegroup
    bind = ${mainMod} SHIFT, W, lockactivegroup, toggle
    bind = ${mainMod} ALT, J, changegroupactive, f
    bind = ${mainMod} ALT, K, changegroupactive, b
    bind = ${mainMod} ALT, L, changegroupactive, f
    bind = ${mainMod} ALT, H, changegroupactive, b
    bind = ${mainMod} CTRL, H, moveintogroup, l
    bind = ${mainMod} CTRL, L, moveintogroup, r
    bind = ${mainMod} CTRL, K, moveintogroup, u
    bind = ${mainMod} CTRL, J, moveintogroup, d
    bind = ${mainMod} CTRL, E, moveoutofgroup

    # Focus / move
    bind = ${mainMod}, H, movefocus, l
    bind = ${mainMod}, L, movefocus, r
    bind = ${mainMod}, J, movefocus, d
    bind = ${mainMod}, K, movefocus, u
    bind = ${mainMod} SHIFT, H, movewindow, l
    bind = ${mainMod} SHIFT, L, movewindow, r
    bind = ${mainMod} SHIFT, J, movewindow, d
    bind = ${mainMod} SHIFT, K, movewindow, u
    bind = ${mainMod} CTRL, Down, workspace, m+1
    bind = ${mainMod} CTRL, Up, workspace, m-1

    # Layout & Overview
    bind = ${mainMod}, Tab, exec, cycle-layout
    bind = ${mainMod}, O, exec, noctalia msg panel-toggle overview

    # Outputs / Monitors
    bind = ${mainMod} SHIFT, Left, focusmonitor, l
    bind = ${mainMod} SHIFT, Right, focusmonitor, r
    bind = ${mainMod} SHIFT, Up, focusmonitor, u
    bind = ${mainMod} SHIFT, Down, focusmonitor, d
    bind = ${mainMod} CTRL SHIFT, Left, movewindow, mon:l
    bind = ${mainMod} CTRL SHIFT, Right, movewindow, mon:r
    bind = ${mainMod} CTRL SHIFT, Up, movewindow, mon:u
    bind = ${mainMod} CTRL SHIFT, Down, movewindow, mon:d

    # Manual Scratchpad (custom user windows)
    bind = ${mainMod} SHIFT, Space, movetoworkspacesilent, special:scratchpad
    bind = ${mainMod}, Space, togglespecialworkspace, scratchpad
    bind = ${mainMod}, Grave, togglespecialworkspace, scratchpad

    # Dedicated Discord and Brave Scratchpads
    bind = ${mainMod} CTRL, D, exec, toggle-scratchpad discord discord
    bind = ${mainMod} CTRL, B, exec, toggle-scratchpad brave brave-origin
    bind = ${mainMod} SHIFT, D, movetoworkspacesilent, special:discord
    bind = ${mainMod} SHIFT, B, movetoworkspacesilent, special:brave

    # Cursor Magnifier / Zoom
    bind = ${mainMod}, Z, exec, hyprctl keyword cursor:zoom_factor 1.5
    bind = ${mainMod} SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1.0
    bind = ${mainMod} CTRL, equal, exec, hyprctl keyword cursor:zoom_factor 2.0
    bind = ${mainMod} CTRL, minus, exec, hyprctl keyword cursor:zoom_factor 1.0

    # Screenshots
    bind = , Print, exec, noctalia msg screenshot-region
    bind = CTRL, Print, exec, noctalia msg screenshot-fullscreen
    bind = SHIFT, Print, exec, noctalia msg screenshot-area

    # Media / Volume / Brightness
    bind = , XF86AudioRaiseVolume, exec, noctalia msg volume-up
    bind = , XF86AudioLowerVolume, exec, noctalia msg volume-down
    bind = , XF86AudioMute, exec, noctalia msg volume-mute
    bind = , XF86AudioMicMute, exec, noctalia msg mic-mute
    bind = , XF86AudioNext, exec, noctalia msg media next
    bind = , XF86AudioPrev, exec, noctalia msg media previous
    bind = , XF86AudioPlay, exec, noctalia msg media toggle
    bind = , XF86AudioPause, exec, noctalia msg media toggle
    bind = , XF86MonBrightnessUp, exec, noctalia msg brightness-up
    bind = , XF86MonBrightnessDown, exec, noctalia msg brightness-down

    # Scroll wheel focus / workspace move
    bind = ${mainMod}, mouse_up, movefocus, l
    bind = ${mainMod}, mouse_down, movefocus, r
    bind = ${mainMod} SHIFT, mouse_up, movewindow, l
    bind = ${mainMod} SHIFT, mouse_down, movewindow, r
    bind = ${mainMod} CTRL, mouse_up, workspace, m-1
    bind = ${mainMod} CTRL, mouse_down, workspace, m+1

    # Mouse window move/resize
    bindm = ${mainMod}, mouse:272, movewindow
    bindm = ${mainMod}, mouse:273, resizewindow

    # Workspace 1..9
    ${workspaceBinds}
  '';
}
