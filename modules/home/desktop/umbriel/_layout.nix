_: {
  programs.umbriel.settings.layout = {
    mode = "scrolling";
    gap = 4;
    width_presets = [0.25 0.33333 0.5 0.66667 0.75 1.0];

    scrolling = {
      direction = "horizontal";
      default_width_fraction = 0.5;
      center_underfull_strip = false;
    };
  };
}
