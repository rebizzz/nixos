{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) lua dsp terminal browser fileExplorer audioSettings editor directions;
in {
  wayland.windowManager.hyprland.settings.bind =
    [
      # Misc
      {_args = ["SUPER + SUPER_L" (dsp "global(\"caelestia:launcher\")") {release = true;}];}
      {_args = ["CTRL + ALT + Delete" (dsp "global(\"caelestia:session\")")];}
      {_args = ["SUPER + N" (dsp "global(\"caelestia:sidebar\")")];}
      {_args = ["CTRL + ALT + C" (dsp "global(\"caelestia:clearNotifs\")") {locked = true;}];}
      {_args = ["SUPER + K" (dsp "global(\"caelestia:showall\")")];}
      {_args = ["SUPER + L" (dsp "global(\"caelestia:lock\")")];}
      {_args = ["SUPER + SHIFT + L" (dsp "exec_cmd(\"systemctl suspend-then-hibernate\")") {locked = true;}];}
      {
        _args = [
          "SUPER + ALT + L"
          (lua ''
            function()
                hl.dispatch(hl.dsp.exec_cmd("caelestia shell -d"))
                hl.dispatch(hl.dsp.global("caelestia:lock"))
            end'')
        ];
      }
      {_args = ["CTRL + SUPER + SHIFT + R" (dsp "exec_cmd(\"qs -c caelestia kill\")") {release = true;}];}
      {_args = ["CTRL + SUPER + ALT + R" (dsp "exec_cmd(\"qs -c caelestia kill; sleep .1; caelestia shell -d\")") {release = true;}];}

      # Workspaces (no groups)
      {_args = ["SUPER + 1" (dsp "focus({workspace = 1})")];}
      {_args = ["SUPER + 2" (dsp "focus({workspace = 2})")];}
      {_args = ["SUPER + 3" (dsp "focus({workspace = 3})")];}
      {_args = ["SUPER + 4" (dsp "focus({workspace = 4})")];}
      {_args = ["SUPER + 5" (dsp "focus({workspace = 5})")];}
      {_args = ["SUPER + 6" (dsp "focus({workspace = 6})")];}
      {_args = ["SUPER + 7" (dsp "focus({workspace = 7})")];}
      {_args = ["SUPER + 8" (dsp "focus({workspace = 8})")];}
      {_args = ["SUPER + 9" (dsp "focus({workspace = 9})")];}
      {_args = ["SUPER + 0" (dsp "focus({workspace = 10})")];}
      {_args = ["SUPER + ALT + 1" (dsp "window.move({workspace = 1})")];}
      {_args = ["SUPER + ALT + 2" (dsp "window.move({workspace = 2})")];}
      {_args = ["SUPER + ALT + 3" (dsp "window.move({workspace = 3})")];}
      {_args = ["SUPER + ALT + 4" (dsp "window.move({workspace = 4})")];}
      {_args = ["SUPER + ALT + 5" (dsp "window.move({workspace = 5})")];}
      {_args = ["SUPER + ALT + 6" (dsp "window.move({workspace = 6})")];}
      {_args = ["SUPER + ALT + 7" (dsp "window.move({workspace = 7})")];}
      {_args = ["SUPER + ALT + 8" (dsp "window.move({workspace = 8})")];}
      {_args = ["SUPER + ALT + 9" (dsp "window.move({workspace = 9})")];}
      {_args = ["SUPER + ALT + 0" (dsp "window.move({workspace = 10})")];}
      {_args = ["SUPER + mouse_up" (dsp "focus({workspace = \"-1\"})")];}
      {_args = ["SUPER + mouse_down" (dsp "focus({workspace = \"+1\"})")];}
      {_args = ["SUPER + Page_Up" (dsp "focus({workspace = \"-1\"})")];}
      {_args = ["SUPER + Page_Down" (dsp "focus({workspace = \"+1\"})")];}
      {_args = ["SUPER + ALT + mouse_up" (dsp "window.move({workspace = \"-1\", follow = true})")];}
      {_args = ["SUPER + ALT + mouse_down" (dsp "window.move({workspace = \"+1\", follow = true})")];}
      {_args = ["SUPER + ALT + S" (dsp "window.move({workspace = \"special:special\"})")];}
      {_args = ["CTRL + SUPER + SHIFT + Down" (dsp "window.move({workspace = \"e+0\"})")];}

      # Window groups
      {_args = ["ALT + Tab" (dsp "window.cycle_next()") {repeating = true;}];}
      {_args = ["SHIFT + ALT + Tab" (dsp "window.cycle_next({next = false})") {repeating = true;}];}
      {_args = ["SUPER + U" (dsp "window.move({out_of_group = true})")];}
      {_args = ["SUPER + Comma" (dsp "group.toggle()")];}
      {_args = ["SUPER + SHIFT + Comma" (dsp "group.lock_active()")];}
      {_args = ["CTRL + ALT + Tab" (dsp "group.next()") {repeating = true;}];}
      {_args = ["CTRL + SHIFT + ALT + Tab" (dsp "group.prev()") {repeating = true;}];}
    ]
    ++ (map (dir: {_args = ["SUPER + ${dir}" (dsp "focus({direction = \"${lib.substring 0 1 dir}\"})")];}) directions)
    ++ (map (dir: {_args = ["SUPER + SHIFT + ${dir}" (dsp "window.move({direction = \"${lib.substring 0 1 dir}\"})")];}) directions)
    ++ [
      {_args = ["SUPER + Z" (dsp "window.drag()") {mouse = true;}];}
      {_args = ["SUPER + mouse:272" (dsp "window.drag()") {mouse = true;}];}
      {_args = ["SUPER + X" (dsp "window.resize()") {mouse = true;}];}
      {_args = ["SUPER + mouse:273" (dsp "window.resize()") {mouse = true;}];}
      {_args = ["CTRL + SUPER + Backslash" (dsp "window.center()")];}
      {_args = ["SUPER + P" (dsp "window.pin()")];}
      {_args = ["SUPER + F" (dsp "window.fullscreen({mode = \"fullscreen\"})")];}
      {_args = ["SUPER + ALT + F" (dsp "window.fullscreen({mode = \"maximized\"})")];}
      {_args = ["SUPER + ALT + Space" (dsp "window.float()")];}
      {_args = ["SUPER + Q" (dsp "window.close()")];}

      # Apps
      {_args = ["SUPER + T" (dsp "exec_cmd(\"${terminal}\")")];}
      {_args = ["SUPER + W" (dsp "exec_cmd(\"${browser}\")")];}
      {_args = ["SUPER + C" (dsp "exec_cmd(\"${editor}\")")];}
      {_args = ["SUPER + E" (dsp "exec_cmd(\"${fileExplorer}\")")];}
      {_args = ["CTRL + ALT + V" (dsp "exec_cmd(\"${audioSettings}\")")];}

      # Utilities
      {_args = ["Print" (dsp "exec_cmd(\"caelestia screenshot\")") {locked = true;}];}
      {_args = ["SUPER + SHIFT + S" (dsp "global(\"caelestia:screenshotFreeze\")")];}
      {_args = ["SUPER + SHIFT + ALT + S" (dsp "global(\"caelestia:screenshot\")")];}
      {_args = ["CTRL + ALT + R" (dsp "exec_cmd(\"caelestia record\")")];}
      {_args = ["SUPER + ALT + R" (dsp "exec_cmd(\"caelestia record -s\")")];}
      {_args = ["SUPER + SHIFT + ALT + R" (dsp "exec_cmd(\"caelestia record -r\")")];}
      {_args = ["SUPER + SHIFT + C" (dsp "exec_cmd(\"hyprpicker -a\")")];}

      # Brightness / media / volume (work while locked)
      {_args = ["XF86MonBrightnessUp" (dsp "global(\"caelestia:brightnessUp\")") {locked = true;}];}
      {_args = ["XF86MonBrightnessDown" (dsp "global(\"caelestia:brightnessDown\")") {locked = true;}];}
      {_args = ["CTRL + SUPER + Space" (dsp "global(\"caelestia:mediaToggle\")") {locked = true;}];}
      {_args = ["XF86AudioPlay" (dsp "global(\"caelestia:mediaToggle\")") {locked = true;}];}
      {_args = ["XF86AudioPause" (dsp "global(\"caelestia:mediaToggle\")") {locked = true;}];}
      {_args = ["CTRL + SUPER + Equal" (dsp "global(\"caelestia:mediaNext\")") {locked = true;}];}
      {_args = ["XF86AudioNext" (dsp "global(\"caelestia:mediaNext\")") {locked = true;}];}
      {_args = ["CTRL + SUPER + Minus" (dsp "global(\"caelestia:mediaPrev\")") {locked = true;}];}
      {_args = ["XF86AudioPrev" (dsp "global(\"caelestia:mediaPrev\")") {locked = true;}];}
      {_args = ["CTRL + SUPER + Backspace" (dsp "global(\"caelestia:mediaStop\")") {locked = true;}];}
      {_args = ["XF86AudioStop" (dsp "global(\"caelestia:mediaStop\")") {locked = true;}];}
      {_args = ["SUPER + SHIFT + M" (dsp "exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")") {locked = true;}];}
      {_args = ["XF86AudioMute" (dsp "exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle\")") {locked = true;}];}
      {_args = ["XF86AudioMicMute" (dsp "exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle\")") {locked = true;}];}
      {
        _args =
          ["XF86AudioRaiseVolume" (dsp "exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 10%+\")")]
          ++ [{locked = true; repeating = true;}];
      }
      {
        _args =
          ["XF86AudioLowerVolume" (dsp "exec_cmd(\"wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-\")")]
          ++ [{locked = true; repeating = true;}];
      }

      # Clipboard / emoji
      {_args = ["SUPER + V" (dsp "exec_cmd(\"caelestia clipboard\")")];}
      {_args = ["SUPER + ALT + V" (dsp "exec_cmd(\"caelestia clipboard -d\")")];}
      {_args = ["SUPER + Period" (dsp "exec_cmd(\"caelestia emoji -p\")")];}
      {
        _args =
          ["CTRL + SHIFT + ALT + V" (dsp "exec_cmd(\"sleep 0.5s && ydotool type -d 1 \\\"$(cliphist list | head -1 | cliphist decode)\\\"\")")]
          ++ [{locked = true;}];
      }

      # Layout cycle: dwindle -> master -> scrolling, via hyprctl (no
      # built-in dispatcher for this exists)
      {
        _args = [
          "SUPER + TAB"
          (lua ''
            (function()
                local layouts = { "dwindle", "master", "scrolling" }
                local idx = 1
                return function()
                    idx = (idx % #layouts) + 1
                    hl.dispatch(hl.dsp.exec_cmd("hyprctl keyword general:layout " .. layouts[idx]))
                end
            end)()'')
        ];
      }
    ];
}
