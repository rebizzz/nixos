_: {
  wayland.windowManager.hyprland.settings = {
    monitor = {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    };

    config = {
      input = {
        kb_layout = "us";
        numlock_by_default = false;
        repeat_rate = 40;
        repeat_delay = 300;
        follow_mouse = 1;
        sensitivity = 0.3;
        accel_profile = "flat";

        touchpad = {
          natural_scroll = true;
          scroll_factor = 1.0;
          clickfinger_behavior = true;
          tap_to_click = true;
          tap_and_drag = true;
          disable_while_typing = true;
        };
      };

      gestures = {
        workspace_swipe_distance = 300;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_forever = false;
      };

      cursor = {
        no_hardware_cursors = false;
      };
    };

    gesture = [
      # 3-finger vertical swipe to switch workspaces
      {
        fingers = 3;
        direction = "vertical";
        action = "workspace";
      }
      # 3-finger horizontal swipe to move across columns, scrolling layout only
      {
        fingers = 3;
        direction = "horizontal";
        action = "scroll_move";
      }
    ];
  };
}
