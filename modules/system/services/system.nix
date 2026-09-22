_: {
  flake.modules.nixos.system-services = {pkgs, ...}: {
    # Modern D-Bus & Core System Services
    services = {
      oo7.enable = true;
      dbus.implementation = "broker";
      gvfs.enable = true;
      flatpak.enable = true;
      tumbler.enable = true;

      kmscon = {
        enable = true;
        hwRender = true;
        useXkbConfig = true;
      };

      smartd = {
        enable = true;
        autodetect = true;
      };

      udev.packages = [pkgs.libmtp];
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
