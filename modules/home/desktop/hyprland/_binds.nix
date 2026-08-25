{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) lua dsp layoutmsg;
in {
  wayland.windowManager.hyprland.settings.bind =
    [
      # Apps / launcher
      {_args = ["SUPER + RETURN" (dsp "exec_cmd(\"kitty\")")];}
      {_args = ["SUPER + D" (dsp "exec_cmd(\"noctalia msg panel-toggle launcher\")")];}
      {_args = ["SUPER + B" (dsp "exec_cmd(\"brave-origin --new-window\")")];}
      {_args = ["SUPER + E" (dsp "exec_cmd(\"nautilus\")")];}
      {_args = ["XF86Calculator" (dsp "exec_cmd(\"noctalia msg panel-toggle yuuto/calculator:panel\")")];}

      # Session / misc
      {_args = ["SUPER + Q" (dsp "window.close()")];}
      {_args = ["SUPER + ALT + L" (dsp "exec_cmd(\"noctalia msg session lock\")")];}
      {_args = ["SUPER + SHIFT + Q" (dsp "exec_cmd(\"noctalia msg panel-toggle session\")")];}
      {_args = ["SUPER + SHIFT + P" (dsp "exec_cmd(\"noctalia msg dpms-off\")")];}
      {_args = ["CTRL + ALT + Delete" (dsp "exit()")];}

      {_args = ["SUPER + Grave" (dsp "focus({workspace = \"previous\"})")];}
      {_args = ["SUPER + Up" (dsp "focus({workspace = \"-1\"})")];}
      {_args = ["SUPER + Down" (dsp "focus({workspace = \"+1\"})")];}

      # Focus / move columns & windows
      {_args = ["SUPER + SHIFT + Left" (dsp "focus({monitor = \"l\"})")];}
      {_args = ["SUPER + SHIFT + Right" (dsp "focus({monitor = \"r\"})")];}
      {_args = ["SUPER + SHIFT + Up" (dsp "focus({monitor = \"u\"})")];}
      {_args = ["SUPER + SHIFT + Down" (dsp "focus({monitor = \"d\"})")];}

      {_args = ["SUPER + CTRL + SHIFT + Left" (dsp "window.move({monitor = \"l\"})")];}
      {_args = ["SUPER + CTRL + SHIFT + Right" (dsp "window.move({monitor = \"r\"})")];}
      {_args = ["SUPER + CTRL + SHIFT + Up" (dsp "window.move({monitor = \"u\"})")];}
      {_args = ["SUPER + CTRL + SHIFT + Down" (dsp "window.move({monitor = \"d\"})")];}

      {_args = ["SUPER + CTRL + J" (dsp "window.move({workspace = \"+1\"})")];}
      {_args = ["SUPER + CTRL + K" (dsp "window.move({workspace = \"-1\"})")];}

      # Window state
      {_args = ["SUPER + T" (dsp "window.float()")];}
      {_args = ["SUPER + F" (dsp "window.fullscreen({mode = \"fullscreen\", layout_aware = false})")];}
      {_args = ["SUPER + M" (dsp "window.fullscreen({mode = \"maximized\"})")];}
      {_args = ["SUPER + W" (dsp "group.toggle()")];}
      {_args = ["SUPER + C" (dsp "window.center()")];}

      # scrolling column messages, no-ops on dwindle
      {_args = ["SUPER + Comma" (layoutmsg "consume_or_expel prev")];}
      {_args = ["SUPER + Period" (layoutmsg "consume_or_expel next")];}
      {_args = ["SUPER + BracketLeft" (layoutmsg "consume")];}
      {_args = ["SUPER + BracketRight" (layoutmsg "expel")];}
      {_args = ["SUPER + R" (layoutmsg "colresize +conf")];}
      {_args = ["SUPER + Minus" (layoutmsg "colresize -0.1")];}
      {_args = ["SUPER + Equal" (layoutmsg "colresize +0.1")];}
      {_args = ["SUPER + SHIFT + Minus" (dsp "window.resize({x = 0, y = -40, relative = true})")];}
      {_args = ["SUPER + SHIFT + Equal" (dsp "window.resize({x = 0, y = 40, relative = true})")];}
      {_args = ["SUPER + P" (layoutmsg "promote")];}
      {_args = ["SUPER + SHIFT + R" (layoutmsg "fit expand")];}

      # scrolling -> dwindle -> scrolling
      {
        _args = [
          "SUPER + Tab"
          (lua ''
            function()
                local layouts = {"scrolling", "dwindle"}
                if hl_layoutIndex == nil then hl_layoutIndex = 1 end
                hl_layoutIndex = (hl_layoutIndex % #layouts) + 1
                hl_currentLayout = layouts[hl_layoutIndex]
                hl.config({general = {layout = layouts[hl_layoutIndex]}})
                hl.notification.create({text = "Layout: " .. layouts[hl_layoutIndex], timeout = 1000})
            end'')
        ];
      }

      # Scratchpad
      {_args = ["SUPER + Space" (dsp "workspace.toggle_special(\"scratch\")")];}
      {_args = ["SUPER + SHIFT + Space" (dsp "window.move({workspace = \"special:scratch\"})")];}

      # Screenshots
      {_args = ["Print" (dsp "exec_cmd(\"noctalia msg screenshot-region\")")];}
      {_args = ["CTRL + Print" (dsp "exec_cmd(\"noctalia msg screenshot-fullscreen\")")];}
      {_args = ["SHIFT + Print" (dsp "exec_cmd(\"noctalia msg screenshot-area\")")];}

      # Media / volume / brightness
      {
        _args = [
          "XF86AudioRaiseVolume"
          (dsp "exec_cmd(\"noctalia msg volume-up\")")
          {
            locked = true;
            repeating = true;
          }
        ];
      }
      {
        _args = [
          "XF86AudioLowerVolume"
          (dsp "exec_cmd(\"noctalia msg volume-down\")")
          {
            locked = true;
            repeating = true;
          }
        ];
      }
      {_args = ["XF86AudioMute" (dsp "exec_cmd(\"noctalia msg volume-mute\")") {locked = true;}];}
      {_args = ["XF86AudioMicMute" (dsp "exec_cmd(\"noctalia msg mic-mute\")") {locked = true;}];}
      {_args = ["XF86AudioNext" (dsp "exec_cmd(\"noctalia msg media next\")") {locked = true;}];}
      {_args = ["XF86AudioPrev" (dsp "exec_cmd(\"noctalia msg media previous\")") {locked = true;}];}
      {_args = ["XF86AudioPlay" (dsp "exec_cmd(\"noctalia msg media toggle\")") {locked = true;}];}
      {_args = ["XF86AudioPause" (dsp "exec_cmd(\"noctalia msg media toggle\")") {locked = true;}];}
      {
        _args = [
          "XF86MonBrightnessUp"
          (dsp "exec_cmd(\"noctalia msg brightness-up\")")
          {
            locked = true;
            repeating = true;
          }
        ];
      }
      {
        _args = [
          "XF86MonBrightnessDown"
          (dsp "exec_cmd(\"noctalia msg brightness-down\")")
          {
            locked = true;
            repeating = true;
          }
        ];
      }

      # Mouse: move/resize floating windows
      {_args = ["SUPER + mouse:272" (dsp "window.drag()") {mouse = true;}];}
      {_args = ["SUPER + mouse:273" (dsp "window.resize()") {mouse = true;}];}
    ]
    # Workspaces 1-9
    ++ (map (i: {_args = ["SUPER + ${toString i}" (dsp "focus({workspace = ${toString i}})")];}) (lib.range 1 9))
    ++ (map (i: {_args = ["SUPER + CTRL + ${toString i}" (dsp "window.move({workspace = ${toString i}})")];}) (lib.range 1 9))
    # vim-style: H/L left/right (layout-aware, works across a fullscreen column + dwindle), J/K down/up
    ++ [
      {_args = ["SUPER + H" (lua "function() hl_focus(\"l\") end")];}
      {_args = ["SUPER + L" (lua "function() hl_focus(\"r\") end")];}
      {_args = ["SUPER + J" (lua "function() hl_focus(\"d\") end")];}
      {_args = ["SUPER + K" (lua "function() hl_focus(\"u\") end")];}
    ]
    # vim-style: H/L swap columns (layout-aware + dwindle), J/K move up/down
    ++ [
      {_args = ["SUPER + SHIFT + H" (lua "function() hl_swapcol(\"l\") end")];}
      {_args = ["SUPER + SHIFT + L" (lua "function() hl_swapcol(\"r\") end")];}
      {_args = ["SUPER + SHIFT + J" (dsp "window.move({direction = \"d\"})")];}
      {_args = ["SUPER + SHIFT + K" (dsp "window.move({direction = \"u\"})")];}
    ];
}
