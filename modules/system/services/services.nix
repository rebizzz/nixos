_: {
  flake.modules.nixos.services = {
    config,
    pkgs,
    lib,
    ...
  }:
    lib.mkIf (config.myConfig.hostClass == "desktop") {
      services = {
        gvfs.enable = true;
        dbus.implementation = "broker";

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
    };
}
