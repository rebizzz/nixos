_: {
  flake.modules.nixos.power = {
    pkgs,
    lib,
    ...
  }: {
    services = {
        thermald.enable = true;
        ananicy = {
          enable = true;
          package = pkgs.ananicy-cpp;
          rulesProvider = pkgs.ananicy-rules-cachyos;
          settings = {
            cgroup_load = false;
            apply_cgroup = false;
            cgroup_realtime_workaround = lib.mkForce false;
          };
        };
        logind.settings.Login = {
          HandleLidSwitch = "ignore";
          HandleLidSwitchExternalPower = "ignore";
          IdleAction = "ignore";
        };
        auto-cpufreq = {
          enable = true;
          settings = {
            charger = {
              governor = "performance";
              energy_performance_preference = "performance";
              turbo = "auto";
            };
            battery = {
              governor = "powersave";
              energy_performance_preference = "power";
              turbo = "auto";
              enable_thresholds = true;
              start_threshold = 20;
              stop_threshold = 80;
            };
          };
        };
      };
      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 100;
        memoryMax = 8 * 1024 * 1024 * 1024;
        priority = 100;
      };
      systemd.oomd = {
        enable = true;
        enableUserSlices = true;
      };
    };
}
