_: {
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";
      repeat_delay = 300;
      repeat_rate = 40;

      follow_mouse = 1;
      sensitivity = 0;

      touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        disable_while_typing = true;
        scroll_factor = 0.8;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 3;
      workspace_swipe_distance = 300;
      workspace_swipe_invert = true;
      workspace_swipe_min_speed_to_force = 30;
      workspace_swipe_cancel_ratio = 0.5;
      workspace_swipe_create_new = true;
      workspace_swipe_direction_lock = false;
      workspace_swipe_forever = true;
      workspace_swipe_use_r = true;
    };

    cursor = {
      no_hardware_cursors = false;
      hide_on_key_press = true;
      inactive_timeout = 30;
    };
  };
}
