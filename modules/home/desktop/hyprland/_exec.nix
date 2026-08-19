{
  pkgs,
  lib,
  ...
}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) lua cursorTheme cursorSize;
in {
  # caelestia's startup hook, ported from execs.lua
  wayland.windowManager.hyprland.settings.on = {
    _args = [
      "hyprland.start"
      (lua ''
        function()
            hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
            hl.exec_cmd("${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1")
            hl.exec_cmd("wl-paste --type text --watch cliphist store")
            hl.exec_cmd("wl-paste --type image --watch cliphist store")
            hl.exec_cmd("trash-empty 30")
            hl.exec_cmd("hyprctl setcursor ${cursorTheme} ${cursorSize}")
            hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme ${cursorTheme}")
            hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size ${cursorSize}")
            hl.exec_cmd("sleep 1 && gammastep")
            hl.exec_cmd("mpris-proxy")
        end'')
    ];
  };
}
