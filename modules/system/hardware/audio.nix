_: {
  flake.modules.nixos.audio = {pkgs, ...}: {
    security.rtkit.enable = true;

    hardware.firmware = [pkgs.sof-firmware];

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.extraConfig."10-disable-idle-suspend" = {
        "monitor.alsa.rules" = [
          {
            matches = [{"node.name" = "~alsa_output.*";}];
            actions = {
              update-props = {
                "session.suspend-timeout-seconds" = 0;
              };
            };
          }
        ];
      };
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings = {
        General.Experimental = true;
        Policy.AutoEnable = false;
      };
    };
  };
}
