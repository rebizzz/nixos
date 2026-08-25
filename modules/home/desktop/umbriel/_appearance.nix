_: {
  # colours intentionally omitted here: noctalia.toml (see _general.nix) supplies
  # the live wallpaper-driven accent/border colours instead of hardcoding them
  programs.umbriel.settings.appearance = {
    prefer_no_csd = true;
    border_width = 2;
    outer_border_width = 0;
    corner_radius = 12;
    animation_ms = 200;

    shadow = {
      enabled = true;
      softness = 45;
      offset_x = 0;
      offset_y = 10;
      color = "#00000088";
    };

    blur = {
      enabled = true;
      optimized = true;
      passes = 3;
      radius = 6;
      noise = 0.02;
      brightness = 0.95;
      contrast = 0.95;
      saturation = 1.25;
    };
  };
}
