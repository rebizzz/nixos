_: {
  flake.modules.nixos.power-server = _: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 100;
      priority = 100;
    };

    systemd.oomd = {
      enable = true;
      enableUserSlices = true;
      enableSystemSlice = false;
    };

    powerManagement.cpuFreqGovernor = "powersave";

    systemd.settings.Manager = {
      RuntimeWatchdogSec = "30s";
      RebootWatchdogSec = "5m";
      KExecWatchdogSec = "5m";
      DefaultTimeoutStopSec = "15s";
      DefaultTimeoutStartSec = "30s";
    };
  };
}
