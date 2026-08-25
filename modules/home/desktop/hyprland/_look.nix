_: {
  wayland.windowManager.hyprland.settings.config = {
    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      resize_on_border = true;
      allow_tearing = false;
      col = {
        active_border = "rgba(9ecfd1ee)";
        inactive_border = "rgba(59595900)";
      };
    };

    decoration = {
      rounding = 12;
      rounding_power = 3;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      dim_inactive = true;
      dim_strength = 0.15;
      dim_special = 0.2;
      dim_around = 0.4;

      shadow = {
        enabled = true;
        range = 30;
        render_power = 3;
        offset = "0 3";
        color = "rgba(00000066)";
      };

      blur = {
        enabled = true;
        size = 5;
        passes = 2;
        noise = 0.0117;
        vibrancy = 0.1696;
        special = true;
        popups = false;
        new_optimizations = true;
      };
    };

    animations.enabled = true;

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      force_default_wallpaper = 0;
      vrr = 1;
      focus_on_activate = false;
      new_float_force_onscreen = 2;
      close_special_on_empty = true;
      background_color = "0x16161d";
      disable_autoreload = true;
      key_press_enables_dpms = true;
      render_unfocused_fps = 15;
    };

    xwayland = {
      enabled = true;
      use_nearest_neighbor = true;
    };

    cursor.hide_on_key_press = true;

    ecosystem = {
      no_update_news = true;
      no_donation_nag = true;
    };

    render.direct_scanout = 2;
  };
}
