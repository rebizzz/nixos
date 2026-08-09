_: {
  flake.modules.nixos.virtualisation = _: {
    virtualisation = {
      docker = {
        enable = true;
        enableOnBoot = false;
      };
    };
  };
}
