_: let
  # Workspace binds generated in Nix – no raw strings, just typed list construction
  workspaceBinds = builtins.concatLists (builtins.genList (i:
    let ws = builtins.toString (i + 1); in [
      "SUPER, ${ws}, workspace, ${ws}"
      "SUPER CTRL, ${ws}, movetoworkspace, ${ws}"
      "SUPER CTRL SHIFT, ${ws}, movetoworkspacesilent, ${ws}"
    ]
  ) 9);
in {
  desktop.hyprland.settings = {
    bind =
      [
        # ── Apps / Launcher ────────────────────────────────────────────────────
        "SUPER, Return, exec, kitty"
        "SUPER, D, exec, noctalia msg panel-toggle launcher"
        "SUPER, B, exec, brave-origin --new-window"
        "SUPER, E, exec, thunar"
        ", XF86Calculator, exec, noctalia msg panel-toggle yuuto/calculator:panel"

        # ── Session / misc ─────────────────────────────────────────────────────
        "SUPER, Q, killactive"
        "SUPER ALT, L, exec, noctalia msg session lock"
        "SUPER SHIFT, Q, exec, noctalia msg panel-toggle session"
        "SUPER, Slash, exec, hyprland-cheatsheet"
        "SUPER SHIFT, Slash, exec, hyprland-cheatsheet"
        "CTRL ALT, Delete, exit"

        # ── Window state ───────────────────────────────────────────────────────
        "SUPER, T, togglefloating"
        "SUPER, F, fullscreen, 0"
        "SUPER, M, fullscreen, 1"
        "SUPER, C, centerwindow"
        "SUPER SHIFT, C, layoutmsg, fit_into_view"
        "SUPER, R, layoutmsg, colresize +conf"
        "SUPER, comma, layoutmsg, swapcol l"
        "SUPER, period, layoutmsg, swapcol r"
        "SUPER, minus, layoutmsg, colresize -0.1"
        "SUPER, equal, layoutmsg, colresize +0.1"

        # ── Window grouping & tabs ─────────────────────────────────────────────
        "SUPER, W, togglegroup"
        "SUPER SHIFT, W, lockactivegroup, toggle"
        "SUPER ALT, J, changegroupactive, f"
        "SUPER ALT, K, changegroupactive, b"
        "SUPER ALT, L, changegroupactive, f"
        "SUPER ALT, H, changegroupactive, b"
        "SUPER CTRL, H, moveintogroup, l"
        "SUPER CTRL, L, moveintogroup, r"
        "SUPER CTRL, K, moveintogroup, u"
        "SUPER CTRL, J, moveintogroup, d"
        "SUPER CTRL, E, moveoutofgroup"

        # ── Focus / move ───────────────────────────────────────────────────────
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, J, movefocus, d"
        "SUPER, K, movefocus, u"
        "SUPER SHIFT, H, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, J, movewindow, d"
        "SUPER SHIFT, K, movewindow, u"
        "SUPER CTRL, Down, workspace, m+1"
        "SUPER CTRL, Up, workspace, m-1"

        # ── Layout & overview ──────────────────────────────────────────────────
        "SUPER, Tab, exec, cycle-layout"
        "SUPER, O, exec, noctalia msg panel-toggle overview"

        # ── Monitor focus / window-to-monitor ──────────────────────────────────
        "SUPER SHIFT, Left, focusmonitor, l"
        "SUPER SHIFT, Right, focusmonitor, r"
        "SUPER SHIFT, Up, focusmonitor, u"
        "SUPER SHIFT, Down, focusmonitor, d"
        "SUPER CTRL SHIFT, Left, movewindow, mon:l"
        "SUPER CTRL SHIFT, Right, movewindow, mon:r"
        "SUPER CTRL SHIFT, Up, movewindow, mon:u"
        "SUPER CTRL SHIFT, Down, movewindow, mon:d"

        # ── Scratchpads ────────────────────────────────────────────────────────
        "SUPER SHIFT, Space, movetoworkspacesilent, special:scratchpad"
        "SUPER, Space, togglespecialworkspace, scratchpad"
        "SUPER, Grave, togglespecialworkspace, scratchpad"
        "SUPER CTRL, D, exec, toggle-scratchpad discord discord"
        "SUPER CTRL, B, exec, toggle-scratchpad brave brave-origin"
        "SUPER SHIFT, D, movetoworkspacesilent, special:discord"
        "SUPER SHIFT, B, movetoworkspacesilent, special:brave"

        # ── Cursor zoom ────────────────────────────────────────────────────────
        "SUPER, Z, exec, hyprctl keyword cursor:zoom_factor 1.5"
        "SUPER SHIFT, Z, exec, hyprctl keyword cursor:zoom_factor 1.0"
        "SUPER CTRL, equal, exec, hyprctl keyword cursor:zoom_factor 2.0"
        "SUPER CTRL, minus, exec, hyprctl keyword cursor:zoom_factor 1.0"

        # ── Screenshots ────────────────────────────────────────────────────────
        ", Print, exec, noctalia msg screenshot-region"
        "CTRL, Print, exec, noctalia msg screenshot-fullscreen"
        "SHIFT, Print, exec, noctalia msg screenshot-area"

        # ── Media / volume / brightness ────────────────────────────────────────
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

        # ── Scroll-wheel binds ─────────────────────────────────────────────────
        "SUPER, mouse_up, movefocus, l"
        "SUPER, mouse_down, movefocus, r"
        "SUPER SHIFT, mouse_up, movewindow, l"
        "SUPER SHIFT, mouse_down, movewindow, r"
        "SUPER CTRL, mouse_up, workspace, m-1"
        "SUPER CTRL, mouse_down, workspace, m+1"
      ]
      # Workspaces 1–9 generated in Nix (no raw string repetition)
      ++ workspaceBinds;

    # Mouse drag-to-move / drag-to-resize
    bindm = [
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];
  };
}
