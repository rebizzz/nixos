_: {
  flake.modules.nixos.system-services = {pkgs, ...}: {
    # Modern D-Bus & Core System Services
    services = {
      dbus.implementation = "broker";
      gvfs.enable = true;
      flatpak.enable = true;
      tumbler.enable = true;

      kmscon = {
        enable = true;
        config.hwaccel = true;
      };

      smartd = {
        enable = true;
        autodetect = true;
      };

      locate = {
        enable = true;
        package = pkgs.plocate;
      };

      udev.packages = [pkgs.libmtp];
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
