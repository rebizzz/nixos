_: {
  flake.modules.homeManager.noctalia = {config, ...}: let
    homeDir = config.home.homeDirectory;
    screenshotsDir = "${homeDir}/Pictures/Screenshots";
    wallpapersDir = "${homeDir}/Pictures/Wallpapers";
    screencastsDir = "${homeDir}/Videos/Screencasts";
    wallpaperPath = "${homeDir}/.config/wallpaper.jpg";
    wallpaperAsset = ../../../assets/wallpaper.jpg;
  in {
    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        plugins = {
          enabled = [
            "noctalia/screen_recorder"
            "aristides/udiskie"
            "yuuto/calculator"
          ];
          auto_update = true;
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
          telemetry_enabled = false;
          screen_time_enabled = true;
          clipboard_history_max_entries = 200;
          clipboard_auto_paste = "ctrl_v";
          avatar_path = "${homeDir}/.face";
          launch_apps_as_systemd_services = true;
          niri_overview_type_to_launch_enabled = true;
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
          };

          screenshot = {
            directory = screenshotsDir;
            freeze_screen = true;
            save_to_file = false;
            copy_to_clipboard = false;
            pipe_to_command = true;
            pipe_command = ''
              sh -c "satty --filename - --copy-command wl-copy --early-exit --output-filename \"${screenshotsDir}/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png\""
            '';
          };
        };

        theme = {
          mode = "dark";
          source = "wallpaper";
          pure_black_dark = true;
          templates = {
            enable_builtin_templates = true;
            builtin_ids = ["ghostty" "gtk3" "gtk4" "niri"];
            enable_community_templates = true;
            community_ids = ["fastfetch" "bat"];
          };
        };

        wallpaper = {
          enabled = true;
          transition_on_startup = true;
          directory = wallpapersDir;
          default.path = wallpaperPath;
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
          enable_overdrive = true;
        };

        location.auto_locate = true;

        hot_corners = {
          enabled = true;
          top_left.action = "launcher";
        };

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
          {type = "mic_mute";}
        ];

        bar.default = {
          capsule = true;
          background_opacity = 0.6;
          start = ["workspaces" "privacy"];
          center = ["media" "clock"];
          end = [
            "tray"
            "notifications"
            "clipboard"
            "udiskie"
            "network"
            "bluetooth"
            "volume"
            "brightness"
            "battery"
            "screen_recorder"
            "control-center"
            "session"
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
            file_manager_cmd = "nautilus";
          };

          "yuuto/calculator" = {
            precision = 8;
            angle_unit = "deg";
          };
        };
      };
    };

    home.file = {
      ".config/wallpaper.jpg".source = wallpaperAsset;
      "Pictures/Wallpapers/default.jpg".source = wallpaperAsset;
      "Pictures/Screenshots/.keep".text = "";
    };
  };
}
