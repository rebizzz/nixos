_: {
  programs.umbriel.settings.input = {
    keyboard = {
      layout = "us";
      repeat_delay = 300;
      repeat_rate = 40;
    };

    touchpad = {
      tap = true;
      natural_scroll = true;
    };

    mouse = {
      accel_profile = "adaptive";
      natural_scroll = false;
    };

    cursor = {
      theme = "Bibata-Modern-Classic";
      size = 24;
      hide_when_typing = true;
      hide_timeout_ms = 30000;
    };

    focus.follows_mouse = true;
    
  };
}
