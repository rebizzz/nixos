{lib, ...}: {
  programs.umbriel.settings.keybinds =
    {
      # Apps / launcher
      "Mod+Return" = {
        action = "spawn:kitty";
        repeat = false;
      };
      "Mod+D" = {
        action = "spawn:noctalia msg panel-toggle launcher";
        repeat = false;
      };
      "Mod+B" = {
        action = "spawn:brave-origin --new-window";
        repeat = false;
      };
      "Mod+E" = {
        action = "spawn:nautilus";
        repeat = false;
      };
      "XF86Calculator" = {
        action = "spawn:noctalia msg panel-toggle yuuto/calculator:panel";
        repeat = false;
      };

      # Session / misc
      "Mod+Q" = "window-close";
      "Mod+Alt+L" = {
        action = "spawn:noctalia msg session lock";
        repeat = false;
      };
      "Mod+Shift+Q" = {
        action = "spawn:noctalia msg panel-toggle session";
        repeat = false;
      };
      "Mod+Shift+P" = {
        action = "spawn:noctalia msg dpms-off";
        repeat = false;
      };
      "Mod+Slash" = "cheatsheet-toggle";
      "Ctrl+Alt+Delete" = "session-quit";

      # Window state
      "Mod+T" = "window-toggle-floating";
      "Mod+F" = "window-toggle-fullscreen";
      "Mod+M" = "window-toggle-maximize";
      "Mod+C" = "window-center";
      "Mod+Shift+C" = "column-center";
      "Mod+R" = "window-cycle-width";
      "Mod+Comma" = "window-consume-left";
      "Mod+Period" = "window-expel-right";
      "Mod+Minus" = "window-modify-width:-0.1";
      "Mod+Equal" = "window-modify-width:+0.1";

      # Focus / move — native to both scrolling and dwindle, no per-layout scripting needed
      "Mod+H" = "window-focus-left";
      "Mod+L" = "window-focus-right";
      "Mod+J" = "window-focus-down";
      "Mod+K" = "window-focus-up";
      "Mod+Shift+H" = "column-move-left";
      "Mod+Shift+L" = "column-move-right";
      "Mod+Shift+J" = "window-move-down";
      "Mod+Shift+K" = "window-move-up";
      "Mod+Ctrl+J" = "window-move-to-workspace-next";
      "Mod+Ctrl+K" = "window-move-to-workspace-previous";
      "Mod+Ctrl+Down" = "window-move-to-workspace-next";
      "Mod+Ctrl+Up" = "window-move-to-workspace-previous";

      "Mod+Tab" = "workspace-set-layout:toggle";
      "Mod+O" = "overview-toggle";

      # Outputs
      "Mod+Shift+Left" = "output-focus-left";
      "Mod+Shift+Right" = "output-focus-right";
      "Mod+Shift+Up" = "output-focus-up";
      "Mod+Shift+Down" = "output-focus-down";
      "Mod+Ctrl+Shift+Left" = "window-move-to-output-left";
      "Mod+Ctrl+Shift+Right" = "window-move-to-output-right";
      "Mod+Ctrl+Shift+Up" = "window-move-to-output-up";
      "Mod+Ctrl+Shift+Down" = "window-move-to-output-down";

      # Scratchpad
      "Mod+Shift+Space" = "window-toggle-scratchpad";
      "Mod+Space" = "scratchpad-toggle";
      "Mod+Grave" = "scratchpad-focus-next";

      # Screenshots
      "Print" = {
        action = "spawn:noctalia msg screenshot-region";
        repeat = false;
      };
      "Ctrl+Print" = {
        action = "spawn:noctalia msg screenshot-fullscreen";
        repeat = false;
      };
      "Shift+Print" = {
        action = "spawn:noctalia msg screenshot-area";
        repeat = false;
      };

      # Media / volume / brightness
      "XF86AudioRaiseVolume" = "spawn:noctalia msg volume-up";
      "XF86AudioLowerVolume" = "spawn:noctalia msg volume-down";
      "XF86AudioMute" = {
        action = "spawn:noctalia msg volume-mute";
        repeat = false;
      };
      "XF86AudioMicMute" = {
        action = "spawn:noctalia msg mic-mute";
        repeat = false;
      };
      "XF86AudioNext" = {
        action = "spawn:noctalia msg media next";
        repeat = false;
      };
      "XF86AudioPrev" = {
        action = "spawn:noctalia msg media previous";
        repeat = false;
      };
      "XF86AudioPlay" = {
        action = "spawn:noctalia msg media toggle";
        repeat = false;
      };
      "XF86AudioPause" = {
        action = "spawn:noctalia msg media toggle";
        repeat = false;
      };
      "XF86MonBrightnessUp" = "spawn:noctalia msg brightness-up";
      "XF86MonBrightnessDown" = "spawn:noctalia msg brightness-down";

      # Scroll wheel focus
      "Mod+WheelUp" = "window-focus-left";
      "Mod+WheelDown" = "window-focus-right";
      "Mod+Shift+WheelUp" = "column-move-left";
      "Mod+Shift+WheelDown" = "column-move-right";
      "Mod+Ctrl+WheelUp" = "window-move-to-workspace-previous";
      "Mod+Ctrl+WheelDown" = "window-move-to-workspace-next";
      "Mod+Ctrl+Page_Up" = "column-move-to-workspace-previous";
      "Mod+Ctrl+Page_Down" = "column-move-to-workspace-next";
    }
    // lib.listToAttrs (map (i: lib.nameValuePair "Mod+${toString i}" "workspace-switch:${toString i}") (lib.range 1 9))
    // lib.listToAttrs (map (i: lib.nameValuePair "Mod+Ctrl+${toString i}" "window-move-to-workspace:${toString i}") (lib.range 1 9))
    // lib.listToAttrs (map (i: lib.nameValuePair "Mod+Ctrl+Shift+${toString i}" "column-move-to-workspace:${toString i}") (lib.range 1 9));
}
