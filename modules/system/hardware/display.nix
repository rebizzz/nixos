_: {
  flake.modules.nixos.display = {pkgs, ...}: {
    programs.niri = {
      enable = true;
      package = pkgs.niri-stable;
    };

    systemd.user.services.niri-flake-polkit.enable = false;

    services.upower.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      config.common = {
        default = ["gnome"];
        "org.freedesktop.impl.portal.ScreenCast" = ["gnome"];
        "org.freedesktop.impl.portal.FileChooser" = ["gtk"];
      };
    };

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
