_: {
  flake.modules.nixos.autoupgrade = {hostVars, ...}: {
    system.autoUpgrade = {
      enable = true;
      flake = "${hostVars.flakeUri}#${hostVars.hostName}";
      dates = "04:00";
      randomizedDelaySec = "45min";
      allowReboot = true;
      rebootWindow = {
        lower = "03:00";
        upper = "05:00";
      };
      operation = "switch";
    };
  };
}
