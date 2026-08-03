_: {
  flake.modules.nixos.audio = {pkgs, ...}: {
    security.rtkit.enable = true;

    hardware.firmware = [pkgs.sof-firmware];

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
    };

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      settings.Policy.AutoEnable = false;
    };
  };
}
