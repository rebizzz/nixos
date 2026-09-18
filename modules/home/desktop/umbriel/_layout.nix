_: {
  programs.umbriel.settings.layout = {
    # Switch between "scrolling", "dwindle", or "master"
    mode = "scrolling";
    gap = 10;
    extent_presets = [0.35 0.5 0.65 1.0];

    scrolling = {
      default_extent_fraction = 0.5;
      center_underfull_strip = false;
    };

    dwindle = {
      preserve_split = true;
    };

    master = {
      position = "left"; # "left" or "right"
      default_width_fraction = 0.55; # 0.1-0.9
    };
  };
}
