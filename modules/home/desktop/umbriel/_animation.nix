_: {
  programs.umbriel.settings.animation = {
    enabled = true;
    duration_ms = 400;
    curve = "standard";

    # umbriel beziers are a single cubic segment, so caelestia's two-segment
    # "emphasized" spline has no exact equivalent; only its accel/decel halves are used.
    beziers = {
      standard = [0.2 0.0 0.0 1.0];
      standardAccel = [0.3 0.0 1.0 1.0];
      standardDecel = [0.0 0.0 0.0 1.0];
      emphasizedAccel = [0.3 0.0 0.8 0.15];
      emphasizedDecel = [0.05 0.7 0.1 1.0];
      expressiveFastSpatial = [0.42 1.67 0.21 0.9];
      expressiveDefaultSpatial = [0.38 1.21 0.22 1.0];
      expressiveSlowSpatial = [0.39 1.29 0.35 0.98];
      expressiveFastEffects = [0.31 0.94 0.34 1.0];
      expressiveDefaultEffects = [0.34 0.8 0.34 1.0];
      expressiveSlowEffects = [0.34 0.88 0.34 1.0];
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
      curve = "expressiveDefaultSpatial";
      style = "popin";
      scale = 0.87;
    };

    windows_out = {
      enabled = true;
      duration_ms = 150;
      curve = "expressiveFastEffects";
      style = "fade";
    };

    windows_move = {
      enabled = true;
      duration_ms = 500;
      curve = "expressiveDefaultSpatial";
    };

    workspaces = {
      enabled = true;
      duration_ms = 650;
      curve = "expressiveSlowSpatial";
    };

    overview = {
      enabled = true;
      duration_ms = 650;
      curve = "expressiveSlowSpatial";
    };

    scratchpad = {
      enabled = true;
      duration_ms = 350;
      curve = "expressiveFastSpatial";
      dim = 0.5;
      blur = true;
      scale = 0.0;
      maximize = false;
      fullscreen = false;
    };

    border = {
      enabled = true;
      duration_ms = 300;
      curve = "expressiveSlowEffects";
    };

    dim_unfocused = {
      enabled = false;
      duration_ms = 200;
      curve = "expressiveDefaultEffects";
      dim = 0.0;
    };

    layers = {
      enabled = true;
      duration_ms = 200;
      curve = "expressiveDefaultEffects";
    };
  };
}
