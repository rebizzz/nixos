_: {
  flake.modules.homeManager.niri = {
    config,
    lib,
    pkgs,
    ...
  }: let
    shadowColor = "#00000066";
    mediaToggle = {
      action.spawn = ["noctalia" "msg" "media" "toggle"];
      allow-when-locked = true;
    };
  in {
    programs.niri = {
      settings = {
        input = {
          keyboard = {
            xkb.layout = "us";
            numlock = false;
          };
          touchpad = {
            tap = true;
            natural-scroll = true;
            accel-speed = 0.2;
            accel-profile = "adaptive";
          };
          mouse = {
            accel-profile = "flat";
            accel-speed = 0.3;
          };
          focus-follows-mouse.enable = true;
          warp-mouse-to-focus.enable = true;
          workspace-auto-back-and-forth = true;
        };

        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          hide-when-typing = true;
          hide-after-inactive-ms = 30000;
        };

        hotkey-overlay.skip-at-startup = true;

        xwayland-satellite = {
          enable = true;
          path = lib.getExe pkgs.xwayland-satellite;
        };

        debug.honor-xdg-activation-with-invalid-serial = true;

        includes = [
          "${config.xdg.configHome}/niri/noctalia.kdl"
        ];

        blur = {
          passes = 3;
          offset = 3.0;
          noise = 0.02;
          saturation = 1.0;
        };

        recent-windows = {
          highlight = {
            active-color = "#9ecfd1";
            urgent-color = "#ffb4ab";
          };
        };

        layout = {
          gaps = 4;
          background-color = "transparent";
          default-column-width = {proportion = 0.5;};
          preset-column-widths = [
            {proportion = 0.33333;}
            {proportion = 0.5;}
            {proportion = 0.66667;}
          ];
          focus-ring.width = 2;
          shadow = {
            enable = true;
            softness = 30;
            spread = 5;
            offset.x = 0;
            offset.y = 5;
            color = shadowColor;
          };

          tab-indicator = {
            enable = true;
            position = "left";
            width = 4;
            corner-radius = 4;
            place-within-column = false;
            hide-when-single-tab = true;
          };
        };

        overview = {
          zoom = 0.6;
          backdrop-color = "#16161d";
          workspace-shadow = {
            softness = 30;
            spread = 5;
            color = shadowColor;
          };
        };

        screenshot-path = "${config.home.homeDirectory}/Pictures/Screenshots/Screenshot_%Y-%m-%d_%H-%M-%S.png";
        prefer-no-csd = true;

        animations = {
          workspace-switch.kind.spring = {
            damping-ratio = 0.80;
            stiffness = 523;
            epsilon = 0.0001;
          };
          horizontal-view-movement.kind.spring = {
            damping-ratio = 0.85;
            stiffness = 423;
            epsilon = 0.0001;
          };
          overview-open-close.kind.spring = {
            damping-ratio = 0.85;
            stiffness = 800;
            epsilon = 0.0001;
          };
          window-movement.kind.spring = {
            damping-ratio = 0.75;
            stiffness = 323;
            epsilon = 0.0001;
          };
          window-resize.kind.spring = {
            damping-ratio = 0.85;
            stiffness = 423;
            epsilon = 0.0001;
          };
          config-notification-open-close.kind.spring = {
            damping-ratio = 0.65;
            stiffness = 923;
            epsilon = 0.001;
          };
          window-open.kind.spring = {
            damping-ratio = 0.80;
            stiffness = 623;
            epsilon = 0.0001;
          };
          window-close.kind.easing = {
            duration-ms = 200;
            curve = "ease-out-quad";
          };
          screenshot-ui-open.kind.easing = {
            duration-ms = 200;
            curve = "ease-out-quad";
          };
          exit-confirmation-open-close.kind.spring = {
            damping-ratio = 0.6;
            stiffness = 800;
            epsilon = 0.01;
          };
        };

        layer-rules = [
          {
            matches = [{namespace = "^noctalia-backdrop";}];
            place-within-backdrop = true;
          }
          {
            matches = [{namespace = "^notifications$";}];
            block-out-from = "screencast";
          }
          {
            matches = [{namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";}];
            background-effect = {
              blur = false;
              xray = false;
            };
          }
        ];

        window-rules = [
          {
            matches = [{is-window-cast-target = true;}];
            focus-ring = {
              active.color = "#e64553";
              inactive.color = "#e64553";
              width = 4;
            };
            border = {
              active.color = "#e64553";
              inactive.color = "#e64553";
              width = 4;
            };
            shadow = {
              color = "#e6455380";
            };
            tab-indicator = {
              active.color = "#e64553";
              inactive.color = "#e64553";
            };
          }
          {
            matches = [{is-floating = true;}];
            background-effect = {
              blur = true;
              xray = false;
            };
          }
          {
            geometry-corner-radius = {
              top-left = 12.0;
              top-right = 12.0;
              bottom-left = 12.0;
              bottom-right = 12.0;
            };
            clip-to-geometry = true;
          }
          {
            matches = [
              {app-id = "^org\\.gnome\\.Calculator$";}
              {app-id = "^gnome-calculator$";}
            ];
            open-floating = true;
          }
          {
            matches = [
              {app-id = "^com\\.gabm\\.satty$";}
              {app-id = "^satty$";}
            ];
            open-floating = true;
            open-on-workspace = "satty";
          }
          {
            matches = [
              {app-id = "^lxqt-policykit.*";}
              {app-id = "^udiskie$";}
              {title = "^Authentication Required$";}
              {title = "^Unlock Keyring$";}
              {title = "^(Enter|Re-enter) (passphrase|pin|password)";}
              {app-id = "^org\\.gnome\\.seahorse\\.Application$";}
            ];
            open-floating = true;
            block-out-from = "screen-capture";
          }
          {
            matches = [
              {
                app-id = "^brave.*";
                title = "^Picture-in-Picture$";
              }
              {
                app-id = "^chromium.*";
                title = "^Picture-in-Picture$";
              }
              {
                app-id = "^brave.*";
                title = ".*Sharing Indicator$";
              }
              {
                app-id = "^brave.*";
                title = "^Save As$";
              }
              {
                app-id = "^brave.*";
                title = "^Open File$";
              }
              {
                app-id = "^brave.*";
                title = "^Extension:.*";
              }
            ];
            open-floating = true;
            geometry-corner-radius = {
              top-left = 8.0;
              top-right = 8.0;
              bottom-left = 8.0;
              bottom-right = 8.0;
            };
          }
          {
            matches = [
              {
                app-id = "^com\\.bitwarden\\.desktop$";
                title = ".*Bitwarden.*";
              }
            ];
            open-floating = true;
          }
          {
            matches = [
              {app-id = "^pavucontrol$";}
              {app-id = "^nm-connection-editor$";}
              {app-id = "^blueman-manager$";}
              {app-id = "^org\\.gnome\\.Nm-connection-editor$";}
            ];
            open-floating = true;
          }
        ];

        spawn-at-startup = [
          {argv = ["dex" "--autostart" "--environment" "niri"];}
        ];

        switch-events.lid-close.action.spawn = ["noctalia" "msg" "session" "lock"];

        gestures.hot-corners.enable = true;

        outputs = lib.genAttrs ["eDP-1" "HDMI-A-1" "DP-1" "DP-2"] (_: {
          variable-refresh-rate = true;
        });

        binds = {
          "Super+Return".action.spawn = "foot";
          "Super+D".action.spawn = ["noctalia" "msg" "panel-toggle" "launcher"];
          "Super+B".action.spawn = ["brave-origin" "--new-window"];
          "Super+E".action.spawn = "nautilus";
          "XF86Calculator".action.spawn = "gnome-calculator";

          "Super+Q".action.close-window = {};
          "Super+Alt+L" = {
            action.spawn = ["noctalia" "msg" "session" "lock"];
            allow-inhibiting = false;
          };
          "Super+Shift+Q".action.spawn = ["noctalia" "msg" "panel-toggle" "session"];
          "Super+Shift+Slash".action.show-hotkey-overlay = {};
          "Super+Escape".action.toggle-keyboard-shortcuts-inhibit = {};
          "Super+Shift+P".action.spawn = ["noctalia" "msg" "dpms-off"];
          "Ctrl+Alt+Delete".action.quit = {};

          "Super+1".action.focus-workspace = 1;
          "Super+2".action.focus-workspace = 2;
          "Super+3".action.focus-workspace = 3;
          "Super+4".action.focus-workspace = 4;
          "Super+5".action.focus-workspace = 5;
          "Super+6".action.focus-workspace = 6;
          "Super+7".action.focus-workspace = 7;
          "Super+8".action.focus-workspace = 8;
          "Super+9".action.focus-workspace = 9;
          "Super+Tab".action.focus-workspace-previous = {};
          "Alt+Tab".action.focus-window-previous = {};
          "Alt+Shift+Tab".action.toggle-overview = {};
          "Super+O" = {
            action.toggle-overview = {};
            repeat = false;
          };

          "Super+H".action.focus-column-left = {};
          "Super+L".action.focus-column-right = {};
          "Super+J".action.focus-window-down = {};
          "Super+K".action.focus-window-up = {};

          "Super+Shift+Left".action.focus-monitor-left = {};
          "Super+Shift+Right".action.focus-monitor-right = {};
          "Super+Shift+Up".action.focus-monitor-up = {};
          "Super+Shift+Down".action.focus-monitor-down = {};

          "Super+Shift+H".action.move-column-left = {};
          "Super+Shift+L".action.move-column-right = {};
          "Super+Shift+J".action.move-window-down = {};
          "Super+Shift+K".action.move-window-up = {};

          "Super+Ctrl+1".action.move-column-to-workspace = 1;
          "Super+Ctrl+2".action.move-column-to-workspace = 2;
          "Super+Ctrl+3".action.move-column-to-workspace = 3;
          "Super+Ctrl+4".action.move-column-to-workspace = 4;
          "Super+Ctrl+5".action.move-column-to-workspace = 5;
          "Super+Ctrl+6".action.move-column-to-workspace = 6;
          "Super+Ctrl+7".action.move-column-to-workspace = 7;
          "Super+Ctrl+8".action.move-column-to-workspace = 8;
          "Super+Ctrl+9".action.move-column-to-workspace = 9;
          "Super+Ctrl+J".action.move-window-to-workspace-down = {};
          "Super+Ctrl+K".action.move-window-to-workspace-up = {};
          "Super+Ctrl+Down".action.move-column-to-workspace-down = {};
          "Super+Ctrl+Up".action.move-column-to-workspace-up = {};

          "Super+Shift+Ctrl+Left".action.move-column-to-monitor-left = {};
          "Super+Shift+Ctrl+Right".action.move-column-to-monitor-right = {};
          "Super+Shift+Ctrl+Up".action.move-column-to-monitor-up = {};
          "Super+Shift+Ctrl+Down".action.move-column-to-monitor-down = {};

          "Super+T".action.toggle-window-floating = {};
          "Super+F".action.fullscreen-window = {};
          "Super+M".action.maximize-column = {};
          "Super+W".action.toggle-column-tabbed-display = {};
          "Super+C".action.center-column = {};
          "Super+Ctrl+C".action.center-visible-columns = {};
          "Super+Ctrl+F".action.expand-column-to-available-width = {};
          "Super+Minus".action.set-column-width = "-10%";
          "Super+Equal".action.set-column-width = "+10%";
          "Super+Shift+Minus".action.set-window-height = "-10%";
          "Super+Shift+Equal".action.set-window-height = "+10%";
          "Super+BracketLeft".action.consume-or-expel-window-left = {};
          "Super+BracketRight".action.consume-or-expel-window-right = {};

          "Super+Alt+C".action.set-dynamic-cast-window = {};
          "Super+Alt+M".action.set-dynamic-cast-monitor = {};
          "Super+Alt+Shift+C".action.clear-dynamic-cast-target = {};
          "Super+Ctrl+Shift+F".action.toggle-windowed-fullscreen = {};
          "Super+Shift+Alt+P".action.spawn = ["noctalia" "msg" "toggle-privacy-mode"];

          "Print".action.spawn = ["noctalia" "msg" "screenshot-region"];
          "Ctrl+Print".action.spawn = ["noctalia" "msg" "screenshot-fullscreen"];
          "Ctrl+Shift+Print".action.screenshot-window = {};
          "Shift+Print" = {
            action.spawn = ["noctalia" "msg" "screenshot-area"];
            repeat = false;
          };

          "XF86AudioRaiseVolume" = {
            action.spawn = ["noctalia" "msg" "volume-up"];
            allow-when-locked = true;
          };
          "XF86AudioLowerVolume" = {
            action.spawn = ["noctalia" "msg" "volume-down"];
            allow-when-locked = true;
          };
          "XF86AudioMute" = {
            action.spawn = ["noctalia" "msg" "volume-mute"];
            allow-when-locked = true;
          };
          "XF86AudioMicMute" = {
            action.spawn = ["noctalia" "msg" "mic-mute"];
            allow-when-locked = true;
          };
          "XF86AudioNext" = {
            action.spawn = ["noctalia" "msg" "media" "next"];
            allow-when-locked = true;
          };
          "XF86AudioPrev" = {
            action.spawn = ["noctalia" "msg" "media" "previous"];
            allow-when-locked = true;
          };
          "XF86AudioPlay" = mediaToggle;
          "XF86AudioPause" = mediaToggle;
          "XF86MonBrightnessUp" = {
            action.spawn = ["noctalia" "msg" "brightness-up"];
            allow-when-locked = true;
          };
          "XF86MonBrightnessDown" = {
            action.spawn = ["noctalia" "msg" "brightness-down"];
            allow-when-locked = true;
          };

          "Super+WheelScrollDown" = {
            action.focus-workspace-down = {};
            cooldown-ms = 150;
          };
          "Super+WheelScrollUp" = {
            action.focus-workspace-up = {};
            cooldown-ms = 150;
          };
          "Super+WheelScrollRight" = {
            action.focus-column-right = {};
            cooldown-ms = 150;
          };
          "Super+WheelScrollLeft" = {
            action.focus-column-left = {};
            cooldown-ms = 150;
          };
          "Super+Shift+WheelScrollDown" = {
            action.focus-column-right = {};
            cooldown-ms = 150;
          };
          "Super+Shift+WheelScrollUp" = {
            action.focus-column-left = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+WheelScrollRight" = {
            action.move-column-right = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+WheelScrollLeft" = {
            action.move-column-left = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+WheelScrollDown" = {
            action.move-column-to-workspace-down = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+WheelScrollUp" = {
            action.move-column-to-workspace-up = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+Shift+WheelScrollDown" = {
            action.move-column-right = {};
            cooldown-ms = 150;
          };
          "Super+Ctrl+Shift+WheelScrollUp" = {
            action.move-column-left = {};
            cooldown-ms = 150;
          };
        };
      };
    };
  };
}
