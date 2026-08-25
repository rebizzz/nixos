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
        pkgs.xdg-desktop-portal-gnome
      ];
      config = {
        common = {
          default = ["gtk"];
        };
        umbriel = {
          default = ["umbriel" "gtk"];
          "org.freedesktop.impl.portal.ScreenCast" = ["umbriel"];
          "org.freedesktop.impl.portal.Screenshot" = ["umbriel"];
          "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
        };
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
  };
}
