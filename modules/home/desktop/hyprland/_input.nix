_: {
  desktop.hyprland.extraConfig = ''
    # Input
    input {
        kb_layout = us
        repeat_delay = 300
        repeat_rate = 40
        follow_mouse = 1
        sensitivity = 0

        touchpad {
            natural_scroll = true
            tap-to-click = true
            disable_while_typing = true
            scroll_factor = 0.8
        }
    }

    # Gestures
    gesture = 3, up, workspace, +1
    gesture = 3, down, workspace, -1
    gesture = 3, left, workspace, -1
    gesture = 3, right, workspace, +1

    # Cursor
    cursor {
        no_hardware_cursors = false
        hide_on_key_press = true
        inactive_timeout = 30
    }
  '';
}
