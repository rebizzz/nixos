{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) lua;
in {
  wayland.windowManager.hyprland.settings.on = {
    _args = [
      "hyprland.start"
      (lua ''
        function()
            hl.exec_cmd("noctalia")
            hl.exec_cmd("dex --autostart --environment Hyprland")
            hl.exec_cmd("hyprpm reload")
        end'')
    ];
  };
}
