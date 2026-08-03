_: {
  flake.modules.nixos.services = {pkgs, ...}: {
    systemd.oomd.enableUserSlices = true;

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
