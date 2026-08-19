_: {
  flake.modules.nixos.cachyos-tuning = {
    lib,
    config,
    ...
  }: let
    diskDevice = lib.removePrefix "/dev/" config.host.disk.device;
  in {
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

      kernel.sysfs = {
        module.zswap.parameters.enabled = false;
        kernel.mm.transparent_hugepage = {
          defrag = "defer+madvise";
          khugepaged.max_ptes_none = 409;
        };
        block.${diskDevice}.queue.scheduler = "kyber";
      };
    };

    systemd.settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultLimitNOFILE = "2048:2097152";
    };

    systemd.user.settings.Manager = {
      DefaultTimeoutStartSec = "15s";
      DefaultLimitNOFILE = "1024:1048576";
    };

    systemd.services.rtkit-daemon.serviceConfig.LogLevelMax = "info";

    security.pam.loginLimits = [
      {
        domain = "@audio";
        type = "-";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@audio";
        type = "-";
        item = "nice";
        value = "-11";
      }
    ];

    services.udev.extraRules = ''
      DEVPATH=="/devices/virtual/misc/cpu_dma_latency", OWNER="root", GROUP="audio", MODE="0660"

      ACTION=="add", SUBSYSTEM=="sound", KERNEL=="card*", DRIVERS=="snd_hda_intel", TEST!="/run/udev/snd-hda-intel-powersave", \
          RUN+="/bin/sh -c 'touch /run/udev/snd-hda-intel-powersave; \
              [ \"$$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)\" != \"Discharging\" ] && \
              cat /sys/module/snd_hda_intel/parameters/power_save > /run/udev/snd-hda-intel-powersave && \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", TEST=="/sys/module/snd_hda_intel", \
          RUN+="/bin/sh -c 'cat /run/udev/snd-hda-intel-powersave 2>/dev/null > /sys/module/snd_hda_intel/parameters/power_save || echo 1 > /sys/module/snd_hda_intel/parameters/power_save'"

      SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", TEST=="/sys/module/snd_hda_intel", \
          RUN+="/bin/sh -c '[ \"$$(cat /sys/module/snd_hda_intel/parameters/power_save)\" != \"0\" ] && \
              cat /sys/module/snd_hda_intel/parameters/power_save > /run/udev/snd-hda-intel-powersave; \
              echo 0 > /sys/module/snd_hda_intel/parameters/power_save'"
    '';
  };
}
