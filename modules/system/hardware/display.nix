_: {
  flake.modules.nixos.display = {pkgs, ...}: {
    services = {
      upower = {
        enable = true;
      };
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        common = {
          default = ["gtk"];
        };
        umbriel = {
          default = ["umbriel" "gtk"];
        };
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland,x11";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };
}
