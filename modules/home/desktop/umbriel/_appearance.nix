_: {
  programs.umbriel.settings = {
    appearance = {
      prefer_no_csd = true;
      border_width = 1;
      outer_border_width = 0;
      corner_radius = 15;

      shadow = {
        enabled = true;
        softness = 8;
        offset_x = 0;
        offset_y = 0;
      };

      blur = {
        enabled = true;
        optimized = false;
        passes = 2;
        radius = 8;
        noise = 0.0117;
        brightness = 0.8172;
        contrast = 0.8916;
        saturation = 1.17;
      };
    };

    colors.shadow = "#00000010";
  };
}
