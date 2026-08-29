_: {
  flake.modules.nixos.gpu = {pkgs, ...}: {
    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        intel-media-driver
        intel-compute-runtime
        libvdpau-va-gl
      ];
    };
  };
}
