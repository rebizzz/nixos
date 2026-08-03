_: {
  flake.modules.nixos.gpu = _: {
    hardware.enableRedistributableFirmware = true;

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
