_: {
  desktop.hyprland.settings = {
    scrolling = {
      column_width = 0.5;
      direction = "right";
      # Quoted because it's a comma-separated float list – kept as a string
      explicit_column_widths = "0.25, 0.333, 0.5, 0.667, 0.75, 1.0";
      focus_fit_method = 1;
      follow_focus = true;
      follow_min_visible = 0.4;
      fullscreen_on_one_column = true;
      wrap_focus = true;
      wrap_swapcol = true;
    };

    dwindle = {
      preserve_split = false;
    };

    master = {
      mfact = 0.50;
      orientation = "left";
    };
  };
}
