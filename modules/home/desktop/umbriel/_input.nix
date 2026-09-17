_: {
  programs.umbriel.settings.input = {
    middle_click_paste = false;

    keyboard = {
      layout = "us";
      repeat_delay = 250;
      repeat_rate = 35;
      numlock_toggle = false;
    };

    touchpad = {
      tap = true;
      natural_scroll = true;
      disable_while_typing = true;
      scroll_factor = 0.5;
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
