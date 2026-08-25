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
          settings_show_advanced = true;
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
            copy_to_clipboard = false;
            pipe_to_command = true;
            pipe_command = ''
              sh -c "satty --filename - --copy-command wl-copy --early-exit --output-filename \"${screenshotsDir}/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png\""
            '';
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
          builtin = "Kanagawa";
          community_palette = "Oxocarbon";
          wallpaper_scheme = "m3-content";
          templates = {
            enable_builtin_templates = true;
            builtin_ids = ["kitty" "gtk3" "gtk4" "hyprland"];
            enable_community_templates = true;
            community_ids = ["fastfetch" "bat"];
          };
        };

        wallpaper = {
          enabled = true;
          transition_on_startup = true;
          directory = wallpapersDir;
          default.path = "${wallpapersDir}/default.jpg";
          last.path = "${wallpapersDir}/default.jpg";
          monitors."eDP-1".path = "${wallpapersDir}/default.jpg";
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
        };

        desktop_widgets = {
          enabled = true;
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
          enable_overdrive = true;
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
            "group:g4"
            "group:g1"
            "group:g2"
            "battery"
            "group:g3"
          ];
          capsule_group = [
            {
              id = "g1";
              enabled = true;
              accordion = false;
              accordion_direction = "end";
              fill = "surface_variant";
              opacity = 1.0;
              padding = 6.0;
              members = ["bluetooth" "screen_recorder" "udiskie"];
            }
            {
              id = "g2";
              enabled = true;
              accordion = true;
              accordion_direction = "end";
              fill = "surface_variant";
              opacity = 1.0;
              padding = 6.0;
              members = ["volume" "spacer_1" "brightness"];
            }
            {
              id = "g3";
              enabled = true;
              accordion = true;
              accordion_direction = "start";
              fill = "surface_variant";
              opacity = 1.0;
              padding = 6.0;
              members = ["session" "control-center" "spacer_2"];
            }
            {
              id = "g4";
              enabled = true;
              accordion = true;
              accordion_direction = "end";
              fill = "surface_variant";
              opacity = 1.0;
              padding = 6.0;
              members = ["network" "spacer_3" "network_tx" "spacer_4" "network_rx"];
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
          spacer_1 = {type = "spacer";};
          spacer_2 = {type = "spacer";};
          spacer_3 = {type = "spacer";};
          spacer_4 = {type = "spacer";};
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
      "Videos/Screencasts/.keep".text = "";
    };
  };
}
