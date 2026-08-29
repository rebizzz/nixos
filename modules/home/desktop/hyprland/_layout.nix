_: {
  wayland.windowManager.hyprland.settings = {
    general = {
      layout = "scrolling";
    };

    scrolling = {
      column_width = 0.5;
      fullscreen_on_one_column = true;
      focus_fit_method = 1;
      follow_focus = true;
      follow_min_visible = 0.4;
      explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0";
      wrap_focus = true;
      wrap_swapcol = true;
      direction = "right";
    };

    dwindle = {
      pseudotile = true;
      preserve_split = false;
    };

    master = {
      mfact = 0.55;
      orientation = "left";
    };
  };
}
