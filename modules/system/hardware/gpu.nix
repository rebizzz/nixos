_: {
  flake.modules.nixos.gpu = {pkgs, ...}: {
    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };
  };
}
