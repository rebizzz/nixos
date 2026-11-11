_: {
  flake.modules.homeManager.noctalia = {
    config,
    pkgs,
    inputs,
    ...
  }: let
    homeDir = config.home.homeDirectory;
    screenshotsDir = "${homeDir}/Pictures/Screenshots";
    wallpapersDir = "${homeDir}/Pictures/Wallpapers";
    screencastsDir = "${homeDir}/Videos/Screencasts";
    wallpaperAsset = ../../../assets/wallpaper.jpg;
  in {
    programs.noctalia = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      systemd.enable = true;

      settings = {
        plugins = {
          enabled = [
            "noctalia/privacy-indicator"
            "noctalia/screen_recorder"
            "aristides/udiskie"
            "yuuto/calculator"
          ];
          auto_update = "all";
          source = [
            {
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
            }
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
            }
          ];
        };

        shell = {
          polkit_agent = true;
          greeter_sync.auto_sync = true;
          telemetry_enabled = true;
          screen_time_enabled = true;
          settings_show_advanced = false;
          password_style = "random";
          clipboard_history_max_entries = 200;
          clipboard_auto_paste = "ctrl_v";
          avatar_path = "${homeDir}/.face";
          launch_apps_as_systemd_services = true;
          font_family = "Inter";
          panel = {
            transparency_mode = "soft";
            control_center_placement = "floating";
            session_placement = "floating";
            wallpaper_placement = "floating";
            open_near_click_launcher = true;
            open_near_click_clipboard = true;
            open_near_click_control_center = true;
          };

          launcher = {
            app_grid = true;
            auto_paste = "ctrl_v";
            compact = true;
          };

          screenshot = {
            directory = screenshotsDir;
            freeze_screen = true;
            save_to_file = false;
            copy_to_clipboard = true;
            annotate = true;
            filename_pattern = "Screenshot_%Y-%m-%d_%H-%M-%S";
          };
        };

        battery = {
          warning_threshold = 15;
        };

        notification = {
          history_retention_hours = 5;
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
          pure_black_dark = true;
          builtin = "Catppuccin";
          community_palette = "Oxocarbon";
          wallpaper_scheme = "m3-content";
          templates = {
            enable_builtin_templates = true;
            builtin_ids = ["kitty" "gtk3" "gtk4" "umbriel"];
            enable_community_templates = true;
            community_ids = ["fastfetch" "bat" "micro"];
          };
        };

        wallpaper = {
          enabled = true;
          transition_on_startup = true;
          directory = wallpapersDir;
          default.path = "${wallpapersDir}/nature/waterfall-bridge.png";
          last.path = "${wallpapersDir}/nature/waterfall-bridge.png";
          monitors."eDP-1".path = "${wallpapersDir}/nature/waterfall-bridge.png";
        };

        backdrop = {
          enabled = true;
          blur_intensity = 0.5;
          tint_intensity = 0.3;
        };

        lockscreen = {
          enabled = true;
          blurred_desktop = true;
          blur_intensity = 0.5;
          tint_intensity = 0.3;
        };

        lockscreen_widgets = {
          enabled = true;
          schema_version = 2;
          widget_order = [
            "lockscreen-login-box@eDP-1"
          ];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = false;
          };
          widget = {
            "lockscreen-login-box@eDP-1" = {
              box_height = 196.0;
              box_width = 810.0;
              cx = 960.0;
              cy = 898.0;
              output = "eDP-1";
              placement_height = 1080.0;
              placement_width = 1920.0;
              rotation = 0.0;
              type = "login_box";
              settings = {
                background_color = "surface_container";
                background_opacity = 0.88;
                background_radius = 12.0;
                center_password_text = false;
                input_opacity = 1.0;
                input_radius = 6.0;
                layout = "regular";
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_media = true;
                show_session_buttons = true;
                show_unlock_hint = true;
                show_weather = true;
              };
            };
          };
        };

        desktop_widgets = {
          enabled = true;
        };

        hot_corners = {
          enabled = false;
          top_left.action = "launcher";
        };

        weather = {
          enabled = true;
        };

        system.monitor = {
          enabled = true;
        };

        nightlight = {
          enabled = true;
          force = true;
          temperature_day = 5100;
          temperature_night = 5000;
        };

        idle = {
          pre_action_fade_seconds = 8;
          behavior = {
            lock = {
              action = "lock";
              enabled = true;
              timeout = 300;
            };
            screen_off = {
              action = "screen_off";
              enabled = true;
              timeout = 360;
            };
            suspend = {
              action = "suspend";
              enabled = true;
              timeout = 900;
            };
          };
        };

        audio = {
          enable_sounds = true;
          enable_power_sounds = true;
          enable_notification_sounds = true;
          enable_screenshot_sounds = true;
          enable_volume_sounds = true;
          enable_overdrive = true;
          sound_theme = "freedesktop";
          sound_volume = 1.0;
        };

        location.auto_locate = true;

        shell.session.actions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "command";
            label = "Hibernate";
            glyph = "hibernate";
            command = "systemctl hibernate";
            variant = "default";
          }
          {
            action = "reboot";
            enabled = true;
            countdown_seconds = 3;
          }
          {
            action = "shutdown";
            enabled = true;
            variant = "destructive";
            countdown_seconds = 5;
          }
        ];

        control_center.shortcuts = [
          {type = "wifi";}
          {type = "bluetooth";}
          {type = "caffeine";}
          {type = "notification";}
          {type = "nightlight";}
          {type = "power_profile";}
        ];

        bar.default = {
          capsule = true;
          background_opacity = 0.6;
          start = ["workspaces" "privacy" "active_window" "group:g5"];
          center = ["media" "clock"];
          end = [
            "lock_keys"
            "tray"
            "notifications"
            "clipboard"
            "screen_recorder"
            "group:g4"
            "group:g1"
            "group:g6"
            "group:g2"
            "group:g3"
          ];
          capsule_group = [
            {
              id = "g1";
              enabled = true;
              accordion = false;
              accordion_direction = "end";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["bluetooth" "udiskie"];
            }
            {
              id = "g2";
              enabled = true;
              accordion = true;
              accordion_direction = "start";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["volume" "brightness" "spacer_1"];
            }
            {
              id = "g3";
              enabled = true;
              accordion = true;
              accordion_direction = "start";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["session" "control-center" "spacer_1"];
            }
            {
              id = "g4";
              enabled = true;
              accordion = true;
              accordion_direction = "start";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["network" "network_tx" "network_rx"];
            }
            {
              id = "g5";
              enabled = true;
              accordion = false;
              accordion_direction = "end";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["cpu" "ram" "temp"];
            }
            {
              id = "g6";
              enabled = true;
              accordion = true;
              accordion_direction = "start";
              border_width = 1.0;
              fill = "surface_container";
              opacity = 1.0;
              padding = 6.0;
              members = ["battery" "power_profile" "spacer_1"];
            }
          ];
        };

        widget = {
          clock = {
            type = "clock";
            format = "{:%H:%M %a, %b %d}";
          };
          media = {
            type = "media";
            hide_when_no_media = true;
          };
          bluetooth = {
            type = "bluetooth";
            hide_when_no_connected_device = true;
          };
          privacy = {
            type = "privacy";
            hide_inactive = true;
          };
          screen_recorder = {
            type = "noctalia/screen_recorder:recorder";
          };
          udiskie = {
            type = "aristides/udiskie:status";
            hide_when_empty = true;
            show_count = true;
          };
          network_tx = {
            visualization = "none";
          };
          network_rx = {
            visualization = "none";
          };
          cpu = {
            visualization = "none";
          };
          ram = {
            visualization = "none";
          };
          temp = {
            visualization = "none";
          };
          lock_keys = {
            display = "full";
            hide_when_off = true;
          };
          taskbar = {
            group_by_workspace = true;
          };
          spacer_1 = {type = "spacer";};
        };

        plugin_settings = {
          "noctalia/screen_recorder" = {
            filename_pattern = "recording_%Y%m%d_%H%M%S";
            copy_to_clipboard = true;
            directory = screencastsDir;
          };

          "aristides/udiskie" = {
            enable_notifications = true;
            auto_open_filemanager = false;
            file_manager_cmd = "thunar";
          };

          "yuuto/calculator" = {
            precision = 8;
            angle_unit = "deg";
            panel_layer = "overlay";
          };
        };
      };
    };

    home.file = {
      "Pictures/Wallpapers/default.jpg".source = wallpaperAsset;
      "Pictures/Screenshots/.keep".text = "";
      "Videos/Screencasts/.keep".text = "";
    };
  };
}
