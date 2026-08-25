{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) dsp;
in {
  wayland.windowManager.hyprland = {
    settings.bind = [
      {_args = ["SUPER + ALT + R" (dsp "submap(\"resize\")")];}
    ];

    submaps.resize.settings.bind = [
      {
        _args = [
          "right"
          (dsp "window.resize({x = 20, y = 0, relative = true})")
          {repeating = true;}
        ];
      }
      {
        _args = [
          "left"
          (dsp "window.resize({x = -20, y = 0, relative = true})")
          {repeating = true;}
        ];
      }
      {
        _args = [
          "up"
          (dsp "window.resize({x = 0, y = -20, relative = true})")
          {repeating = true;}
        ];
      }
      {
        _args = [
          "down"
          (dsp "window.resize({x = 0, y = 20, relative = true})")
          {repeating = true;}
        ];
      }
      {_args = ["escape" (dsp "submap(\"reset\")")];}
      {_args = ["return" (dsp "submap(\"reset\")")];}
    ];
  };
}
