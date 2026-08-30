_: {
  flake.modules.nixos.services = {
    config,
    pkgs,
    lib,
    hostVars ? null,
    ...
  }:
    lib.mkMerge [
      (lib.mkIf (config.myConfig.hostClass == "desktop") {
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
      })
      (lib.mkIf (config.myConfig.hostClass == "server") {
        environment.systemPackages = [
          pkgs.cockpit
        ];

        services = {
          cockpit = {
            enable = true;
            port = 9090;
            settings.WebService = {
              AllowUnencrypted = true;
              ProtocolHeader = "X-Forwarded-Proto";
              ForwardedForHeader = "X-Forwarded-For";
              UrlRoot = "/cockpit";
              Origins = lib.mkForce "http://* https://* ws://* wss://*";
            };
          };

          tailscale = {
            enable = true;
            useRoutingFeatures = "both";
          };

          irqbalance.enable = true;

          udev.extraRules = ''
            ACTION=="add|change", SUBSYSTEM=="block", ENV{ID_BUS}=="ata", ATTR{queue/rotational}=="1", RUN+="${pkgs.hdparm}/bin/hdparm -B 254 -S 0 /dev/%k"
          '';

          smartd = {
            enable = true;
            autodetect = false;
            devices = hostVars.smartDevices;
            notifications.mail.enable = false;
          };

          fstrim = {
            enable = true;
            interval = "weekly";
          };
        };
      })
    ];
}
