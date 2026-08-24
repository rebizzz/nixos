{inputs, ...}: {
  flake.modules.homeManager.umbriel = {...}: {
    imports = [inputs.umbriel.homeModules.default];

    programs.umbriel = {
      enable = true;
      settings = {
        general = {
          autostart = ["noctalia" "dex --autostart --environment umbriel"];
          mod_key = "Super";
          show_cheatsheet = false;
          focus_on_activate = true;
        };

        workspaces = {
          back_and_forth = true;
        };

        input = {
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
            accel_profile = "flat";
            natural_scroll = false;
          };
          cursor = {
            theme = "Bibata-Modern-Classic";
            size = 24;
            hide_when_typing = true;
            hide_timeout_ms = 30000;
          };
          focus = {
            follows_mouse = true;
          };
        };

        layout = {
          mode = "scrolling";
          gap = 4;
          width_presets = [0.25 0.33333 0.5 0.66667 0.75 1.0];
          scrolling = {
            direction = "horizontal";
            default_width_fraction = 0.5;
            center_underfull_strip = false;
          };
        };

        appearance = {
          prefer_no_csd = true;
          border_width = 2;
          corner_radius = 12;
          border_focused = "#9ecfd1";
          border_unfocused = "#24242d99";
          scratchpad_border_focused = "#e5c07bcc";
          scratchpad_border_unfocused = "#3a302299";
          insert_hint_color = "#9ecfd166";
          backdrop_color = "#0c0c0f";
          animation_ms = 240;
          shadow = {
            enabled = true;
            softness = 45;
            offset_x = 0;
            offset_y = 10;
            color = "#00000088";
          };
          blur = {
            enabled = true;
            optimized = true;
            passes = 3;
            radius = 6;
            noise = 0.02;
            brightness = 0.95;
            contrast = 0.95;
            saturation = 1.25;
          };
        };

        output = {
          "eDP-1" = {
            vrr = "fullscreen";
          };
          "DP-1" = {
            vrr = "fullscreen";
          };
          "DP-2" = {
            vrr = "fullscreen";
          };
          "HDMI-A-1" = {
            vrr = "fullscreen";
          };
        };

        overview = {
          zoom = 0.55;
          workspace_background = "#0c0c0f66";
        };

        hot_corners = {
          top_left = {
            enabled = true;
            delay_ms = 500;
            action = "overview-open";
          };
        };

        # ---------------------------------------------------------------------------
        # Keybinds
        # ---------------------------------------------------------------------------
        keybinds = {
          # Launchers & Applications
          "Mod+Return" = "spawn:kitty";
          "Mod+D" = "spawn:noctalia msg panel-toggle launcher";
          "Mod+B" = "spawn:brave-origin --new-window";
          "Mod+E" = "spawn:nautilus";
          "XF86Calculator" = "spawn:noctalia msg panel-toggle yuuto/calculator:panel";

          # Window actions
          "Mod+Q" = "window-close";
          "Mod+T" = "window-toggle-floating";
          "Mod+F" = "window-toggle-fullscreen";
          "Mod+M" = "window-toggle-maximize";
          "Mod+Ctrl+M" = "window-toggle-maximize-to-edges";
          "Mod+R" = "window-cycle-width";
          "Mod+C" = "window-center";
          "Mod+BracketLeft" = "window-consume-left";
          "Mod+BracketRight" = "window-expel-right";
          "Mod+Comma" = "window-consume-left";
          "Mod+Period" = "window-expel-right";

          # Session & lock
          "Mod+Alt+L" = "spawn:noctalia msg session lock";
          "Mod+Shift+Q" = "spawn:noctalia msg panel-toggle session";
          "Mod+Shift+Slash" = "cheatsheet-toggle";
          "Mod+Shift+P" = "spawn:noctalia msg dpms-off";
          "Ctrl+Alt+Delete" = "session-quit";

          # Overview & Navigation
          "Mod+O" = "overview-toggle";
          "Mod+Tab" = "workspace-set-layout:toggle";

          # Window sizing & modifications (from Niri history)
          "Mod+Minus" = "window-modify-width:-0.1";
          "Mod+Equal" = "window-modify-width:+0.1";

          # Focus navigation (vim-keys)
          "Mod+H" = "window-focus-left";
          "Mod+L" = "window-focus-right";
          "Mod+J" = "window-focus-down";
          "Mod+K" = "window-focus-up";

          # Window & Column movement (vim-keys from Niri history)
          "Mod+Shift+H" = "column-move-left";
          "Mod+Shift+L" = "column-move-right";
          "Mod+Shift+J" = "window-move-down";
          "Mod+Shift+K" = "window-move-up";
          "Mod+Ctrl+J" = "window-move-to-workspace-next";
          "Mod+Ctrl+K" = "window-move-to-workspace-previous";

          # Multi-Monitor output focus
          "Mod+Shift+Left" = "output-focus-left";
          "Mod+Shift+Right" = "output-focus-right";
          "Mod+Shift+Up" = "output-focus-up";
          "Mod+Shift+Down" = "output-focus-down";

          # Move window / column across monitors
          "Mod+Ctrl+Shift+Left" = "window-move-to-output-left";
          "Mod+Ctrl+Shift+Right" = "window-move-to-output-right";
          "Mod+Ctrl+Shift+Up" = "window-move-to-output-up";
          "Mod+Ctrl+Shift+Down" = "window-move-to-output-down";

          # Workspace focus (1-9)
          "Mod+1" = "workspace-switch:1";
          "Mod+2" = "workspace-switch:2";
          "Mod+3" = "workspace-switch:3";
          "Mod+4" = "workspace-switch:4";
          "Mod+5" = "workspace-switch:5";
          "Mod+6" = "workspace-switch:6";
          "Mod+7" = "workspace-switch:7";
          "Mod+8" = "workspace-switch:8";
          "Mod+9" = "workspace-switch:9";

          # Move window to workspace (1-9)
          "Mod+Ctrl+1" = "window-move-to-workspace:1";
          "Mod+Ctrl+2" = "window-move-to-workspace:2";
          "Mod+Ctrl+3" = "window-move-to-workspace:3";
          "Mod+Ctrl+4" = "window-move-to-workspace:4";
          "Mod+Ctrl+5" = "window-move-to-workspace:5";
          "Mod+Ctrl+6" = "window-move-to-workspace:6";
          "Mod+Ctrl+7" = "window-move-to-workspace:7";
          "Mod+Ctrl+8" = "window-move-to-workspace:8";
          "Mod+Ctrl+9" = "window-move-to-workspace:9";

          # Move window across workspaces (adjacent)
          "Mod+Ctrl+Down" = "window-move-to-workspace-next";
          "Mod+Ctrl+Up" = "window-move-to-workspace-previous";

          # Scratchpad
          "Mod+Shift+Space" = "window-move-to-scratchpad";
          "Mod+Space" = "scratchpad-toggle";
          "Mod+Ctrl+Space" = "window-restore-from-scratchpad";
          "Mod+grave" = "scratchpad-focus-next";

          # Screenshots (Noctalia)
          "Print" = "spawn:noctalia msg screenshot-region";
          "Ctrl+Print" = "spawn:noctalia msg screenshot-fullscreen";
          "Shift+Print" = "spawn:noctalia msg screenshot-area";

          # Noctalia extras
          "Mod+Shift+Alt+P" = "spawn:noctalia msg toggle-privacy-mode";

          # Media keys
          "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
          "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
          "XF86AudioMute" = "spawn:noctalia msg volume-mute";
          "XF86AudioMicMute" = "spawn:noctalia msg mic-mute";
          "XF86AudioNext" = "spawn:noctalia msg media next";
          "XF86AudioPrev" = "spawn:noctalia msg media previous";
          "XF86AudioPlay" = "spawn:noctalia msg media toggle";
          "XF86AudioPause" = "spawn:noctalia msg media toggle";
          "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";
          "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";

          # Scroll wheel navigation
          "Mod+WheelUp" = "window-focus-left";
          "Mod+WheelDown" = "window-focus-right";
          "Mod+Shift+WheelUp" = "column-move-left";
          "Mod+Shift+WheelDown" = "column-move-right";
          "Mod+Ctrl+WheelUp" = "window-move-to-workspace-previous";
          "Mod+Ctrl+WheelDown" = "window-move-to-workspace-next";
        };

        # ---------------------------------------------------------------------------
        # Window rules — Identical matching to niri.nix
        # ---------------------------------------------------------------------------
        window_rule = [
          # Kitty — blur
          {
            match.app_id = "^kitty$";
            blur = true;
          }
          # Screenshot annotation tool
          {
            match.app_id = "^(com\\.gabm\\.satty|satty)$";
            default_floating = true;
          }
          # Auth / Polkit / Keyring dialogs
          {
            match.app_id = "^lxqt-policykit.*";
            default_floating = true;
          }
          {
            match.app_id = "^udiskie$";
            default_floating = true;
          }
          {
            match.title = "^Authentication Required$";
            default_floating = true;
          }
          {
            match.title = "^Unlock Keyring$";
            default_floating = true;
          }
          {
            match.title = "^(Enter|Re-enter) (passphrase|pin|password)";
            default_floating = true;
          }
          {
            match.app_id = "^org\\.gnome\\.seahorse\\.Application$";
            default_floating = true;
          }
          # Brave / Chromium PiP + popups + dialogs
          {
            match = {
              app_id = "^brave.*";
              title = "^Picture-in-Picture$";
            };
            default_floating = true;
          }
          {
            match = {
              app_id = "^chromium.*";
              title = "^Picture-in-Picture$";
            };
            default_floating = true;
          }
          {
            match = {
              app_id = "^brave.*";
              title = ".*Sharing Indicator$";
            };
            default_floating = true;
          }
          {
            match = {
              app_id = "^brave.*";
              title = "^Save As$";
            };
            default_floating = true;
          }
          {
            match = {
              app_id = "^brave.*";
              title = "^Open File$";
            };
            default_floating = true;
          }
          {
            match = {
              app_id = "^brave.*";
              title = "^Extension:.*";
            };
            default_floating = true;
          }
          # Bitwarden
          {
            match.app_id = "^[bB]itwarden.*";
            default_floating = true;
          }
          # System control tools
          {
            match.app_id = "^pavucontrol$";
            default_floating = true;
          }
          {
            match.app_id = "^nm-connection-editor$";
            default_floating = true;
          }
          {
            match.app_id = "^blueman-manager$";
            default_floating = true;
          }
          {
            match.app_id = "^org\\.gnome\\.Nm-connection-editor$";
            default_floating = true;
          }
        ];

        # ---------------------------------------------------------------------------
        # Layer rules — Noctalia shell surfaces blur exclusion
        # ---------------------------------------------------------------------------
        layer_rule = [
          {
            match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$";
            blur = false;
          }
        ];
      };
    };
  };
}
