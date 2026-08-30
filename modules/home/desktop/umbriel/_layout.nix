_: {
  programs.umbriel.settings.layout = {
    # Switch between "scrolling", "dwindle", or "master"
    mode = "scrolling";
    gap = 4;
    width_presets = [0.25 0.33333 0.5 0.66667 0.75 1.0];

    scrolling = {
      direction = "horizontal";
      default_width_fraction = 0.5;
      center_underfull_strip = false;
    };

    dwindle = {
      preserve_split = false;
    };

    master = {
      position = "left"; # "left" or "right"
      default_width_fraction = 0.55; # 0.1-0.9
    };
  };
}
