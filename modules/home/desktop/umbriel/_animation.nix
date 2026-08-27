_: {
  programs.umbriel.settings.animation = {
    enabled = true;
    duration_ms = 250;
    curve = "easeOutQuint";

    beziers = {
      easeOutQuint = [0.23 1.0 0.32 1.0];
      easeInOutCubic = [0.65 0.05 0.36 1.0];
      linear = [0.0 0.0 1.0 1.0];
      almostLinear = [0.5 0.5 0.75 1.0];
      quick = [0.15 0.0 0.1 1.0];
      myBezier = [0.05 0.9 0.1 1.05];
      easeOutExpo = [0.16 1.0 0.3 1.0];
      emphasizedDecel = [0.05 0.7 0.1 1.0];
      emphasizedAccel = [0.3 0.0 0.8 0.15];
      standard = [0.2 0.0 0.0 1.0];
      specialWorkSwitch = [0.05 0.7 0.1 1.0];
      expressiveFastSpatial = [0.42 1.67 0.21 0.9];
    };

    springs = {
      easy = {
        damping = 2.42;
        stiffness = 238;
      };
      bouncy = {
        damping = 0.5;
        stiffness = 200;
      };
      snappy = {
        damping = 0.8;
        stiffness = 350;
      };
      smooth = {
        damping = 1.0;
        stiffness = 250;
      };
    };

    windows_in = {
      enabled = true;
      duration_ms = 500;
      curve = "emphasizedDecel";
      style = "popin";
      scale = 0.87;
    };

    windows_out = {
      enabled = true;
      duration_ms = 300;
      curve = "emphasizedAccel";
      style = "fade";
    };

    windows_move = {
      enabled = true;
      duration_ms = 600;
      curve = "standard";
    };

    workspaces = {
      enabled = true;
      duration_ms = 500;
      curve = "standard";
    };

    layers = {
      enabled = true;
      duration_ms = 500;
      curve = "standard";
    };

    border = {
      enabled = true;
      duration_ms = 600;
      curve = "standard";
    };

    scratchpad = {
      enabled = true;
      duration_ms = 250;
      curve = "easeOutQuint";
      dim = 0.5;
      blur = true;
      scale = 0.0;
      maximize = true;
      fullscreen = false;
    };

    dim_unfocused = {
      enabled = false;
      duration_ms = 600;
      curve = "standard";
      dim = 0.0;
    };
  };
}
