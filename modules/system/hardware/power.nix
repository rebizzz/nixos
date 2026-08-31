{inputs, ...}: {
  flake.modules.nixos.power = {
    pkgs,
    lib,
    config,
    ...
  }: let
    user = config.users.users.${config.myConfig.user.name};
  in {
    # Power Management & Dynamic Frequency Scaling
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

      logind.settings.Login = {
        HandleLidSwitch = "ignore";
        HandleLidSwitchExternalPower = "ignore";
        IdleAction = "ignore";
      };

      # I/O Scheduler & Latency Optimization Rules
      udev.extraRules = ''
        DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
        ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"
        ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
        ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      '';
    };

    # Memory Compression (zRAM) & Userspace OOM Prevention
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

    # Kernel & Memory Tuning (CachyOS sysctls)
    boot = {
      blacklistedKernelModules = ["iTCO_wdt"];

      kernel.sysctl = {
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_writeback_centisecs" = 1500;
        "vm.max_map_count" = 2147483642;
        "net.core.netdev_max_backlog" = 16384;
        "fs.file-max" = 2097152;
        "kernel.printk" = "3 3 3 3";
        "kernel.watchdog" = 0;
      };
    };

    # Systemd Performance & Sleep/Lock Configuration
    systemd = {
      tmpfiles.rules = [
        "w /sys/module/zswap/parameters/enabled - - - - 0"
        "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
        "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
        "w /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
      ];

      settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultLimitNOFILE = "2048:2097152";
      };

      user.settings.Manager = {
        DefaultTimeoutStartSec = "15s";
        DefaultLimitNOFILE = "1024:1048576";
      };

      services.rtkit-daemon.serviceConfig.LogLevelMax = "info";

      sleep.settings.Sleep = {
        HibernateMode = "platform shutdown";
        HibernateDelaySec = "30min";
      };

      services.lock-before-sleep = {
        description = "Lock the session before suspend/hibernate";
        before = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
        wantedBy = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
        serviceConfig = {
          Type = "oneshot";
          User = user.name;
          Environment = "XDG_RUNTIME_DIR=/run/user/${toString (
            if user.uid != null
            then user.uid
            else 1000
          )}";
          ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia msg session lock";
          TimeoutStartSec = "10s";
        };
      };
    };
  };
}
