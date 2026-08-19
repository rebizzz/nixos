{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) lua cursorTheme cursorSize sleepGestureCmd;
in {
  wayland.windowManager.hyprland.settings = {
    monitor = {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    };

    config = {
      general = {
        layout = "dwindle";
        allow_tearing = false;
        gaps_workspaces = 20;
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        # border colours: see _extra.nix, they come from the live scheme
      };

      dwindle = {
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
      };

      scrolling = {
        fullscreen_on_one_column = true;
        focus_fit_method = 1;
        column_width = 0.5;
        follow_focus = true;
        follow_min_visible = 0.0;
        explicit_column_widths = "0.35, 0.5, 0.65, 1.0";
      };

      input = {
        kb_layout = "us";
        numlock_by_default = false;
        repeat_delay = 250;
        repeat_rate = 35;
        focus_on_close = 1;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.3;
        };
      };

      binds.scroll_event_delay = 0;
      cursor.hotspot_padding = 1;

      decoration = {
        rounding = 15;
        blur = {
          enabled = true;
          xray = false;
          special = false;
          ignore_opacity = true;
          new_optimizations = true;
          popups = true;
          input_methods = true;
          size = 8;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 15;
          render_power = 4;
          # colour: see _extra.nix
        };
      };

      animations.enabled = true;

      gestures = {
        workspace_swipe_distance = 700;
        workspace_swipe_cancel_ratio = 0.15;
        workspace_swipe_min_speed_to_force = 5;
        workspace_swipe_direction_lock = true;
        workspace_swipe_direction_lock_threshold = 10;
        workspace_swipe_create_new = true;
      };

      # group border/text/bar colours: see _extra.nix
      group.groupbar = {
        font_family = "JetBrains Mono NF";
        font_size = 15;
        gradients = true;
        gradient_round_only_edges = false;
        gradient_rounding = 5;
        height = 25;
        indicator_height = 0;
        gaps_in = 3;
        gaps_out = 3;
      };

      misc = {
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        disable_hyprland_logo = true;
        force_default_wallpaper = 0;
        on_focus_under_fullscreen = 2;
        allow_session_lock_restore = true;
        middle_click_paste = false;
        focus_on_activate = true;
        session_lock_xray = true;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        # background_color: see _extra.nix
      };

      debug.error_position = 1;
    };

    curve = [
      {_args = ["specialWorkSwitch" {type = "bezier"; points = [[0.05 0.7] [0.1 1]];}];}
      {_args = ["emphasizedAccel" {type = "bezier"; points = [[0.3 0] [0.8 0.15]];}];}
      {_args = ["emphasizedDecel" {type = "bezier"; points = [[0.05 0.7] [0.1 1]];}];}
      {_args = ["standard" {type = "bezier"; points = [[0.2 0] [0 1]];}];}
    ];

    animation = [
      {leaf = "layersIn"; enabled = true; speed = 5; bezier = "emphasizedDecel"; style = "slide";}
      {leaf = "layersOut"; enabled = true; speed = 4; bezier = "emphasizedAccel"; style = "slide";}
      {leaf = "fadeLayers"; enabled = true; speed = 5; bezier = "standard";}
      {leaf = "windowsIn"; enabled = true; speed = 5; bezier = "emphasizedDecel";}
      {leaf = "windowsOut"; enabled = true; speed = 3; bezier = "emphasizedAccel";}
      {leaf = "windowsMove"; enabled = true; speed = 6; bezier = "standard";}
      {leaf = "workspaces"; enabled = true; speed = 5; bezier = "standard";}
      {leaf = "specialWorkspace"; enabled = true; speed = 4; bezier = "specialWorkSwitch"; style = "slidefadevert 15%";}
      {leaf = "fade"; enabled = true; speed = 6; bezier = "standard";}
      {leaf = "fadeDim"; enabled = true; speed = 6; bezier = "standard";}
      {leaf = "border"; enabled = true; speed = 6; bezier = "standard";}
    ];

    gesture = [
      {fingers = 4; direction = "horizontal"; action = "workspace";}
      {fingers = 3; direction = "up"; action = "special"; workspace_name = "special";}
      # 3-finger-down (specialws toggle) lives in _extra.nix, needs toggle()
      {
        fingers = 4;
        direction = "down";
        action = lua "function() hl.exec_cmd(\"${sleepGestureCmd}\") end";
      }
    ];

    env = [
      {_args = ["QT_QPA_PLATFORMTHEME" "qtengine"];}
      {_args = ["QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"];}
      {_args = ["QT_AUTO_SCREEN_SCALE_FACTOR" "1"];}
      {_args = ["XCURSOR_THEME" cursorTheme];}
      {_args = ["XCURSOR_SIZE" cursorSize];}
      {_args = ["GDK_BACKEND" "wayland,x11"];}
      {_args = ["QT_QPA_PLATFORM" "wayland;xcb"];}
      {_args = ["SDL_VIDEODRIVER" "wayland,x11,windows"];}
      {_args = ["CLUTTER_BACKEND" "wayland"];}
      {_args = ["ELECTRON_OZONE_PLATFORM_HINT" "auto"];}
      {_args = ["XDG_CURRENT_DESKTOP" "Hyprland"];}
      {_args = ["XDG_SESSION_TYPE" "wayland"];}
      {_args = ["XDG_SESSION_DESKTOP" "Hyprland"];}
      {_args = ["_JAVA_AWT_WM_NONREPARENTING" "1"];}
    ];
  };
}
