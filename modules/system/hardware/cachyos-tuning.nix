_: {
  flake.modules.nixos.cachyos-tuning = {...}: {
    boot = {
      blacklistedKernelModules = [
        "iTCO_wdt"
      ];

      kernel.sysctl = {
        "vm.vfs_cache_pressure" = 50;
        "vm.dirty_writeback_centisecs" = 1500;
        "net.core.netdev_max_backlog" = 4096;
        "fs.file-max" = 2097152;
        "kernel.printk" = "3 3 3 3";
        "kernel.watchdog" = 0;
      };
    };

    systemd.tmpfiles.rules = [
      "w /sys/module/zswap/parameters/enabled - - - - 0"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w /sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none - - - - 409"
    ];

    systemd.settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultLimitNOFILE = "2048:2097152";
    };

    systemd.user.settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultLimitNOFILE = "1024:1048576";
    };

    systemd.services.rtkit-daemon.serviceConfig.LogLevelMax = "info";

    services.udev.extraRules = ''
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"
      ACTION=="add|change", KERNEL=="nvme[0-9]*n[0-9]*", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
      ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };
}
