_: {
  desktop.hyprland.extraConfig = ''
    # Layouts
    scrolling {
        column_width = 0.5
        direction = right
        explicit_column_widths = 0.25, 0.333, 0.5, 0.667, 0.75, 1.0
        focus_fit_method = 1
        follow_focus = true
        follow_min_visible = 0.4
        fullscreen_on_one_column = true
        wrap_focus = true
        wrap_swapcol = true
    }

    dwindle {
        preserve_split = false
    }

    master {
        mfact = 0.50
        orientation = left
    }
  '';
}
