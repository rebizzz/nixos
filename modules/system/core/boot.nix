_: {
  flake.modules.nixos.boot = {
    lib,
    pkgs,
    ...
  }: let
    blockedModules = [
      "esp4"
      "esp6"
      "rxrpc"
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "ax25"
      "netrom"
      "rose"
      "atm"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
    ];
  in {
    boot = {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          useOSProber = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
        timeout = 5;
      };

      kernelPackages = pkgs.linuxPackages;
      kernelModules = ["tcp_bbr"];
      kernelParams = [
        "quiet"
        "splash"

        "rd.udev.log_level=3"
        "udev.log_level=0"
        "rd.systemd.show_status=auto"
      ];
      consoleLogLevel = 3;
      supportedFilesystems = ["udf" "nfs"];
      tmp.cleanOnBoot = true;

      kernel.sysctl = {
        "vm.swappiness" = 100;
        "vm.page-cluster" = 0;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.dirty_bytes" = 268435456;
        "vm.dirty_background_bytes" = 67108864;
        "vm.dirty_expire_centisecs" = 1500;

        "kernel.nmi_watchdog" = 0;
        "kernel.unprivileged_userns_clone" = 1;
        "kernel.sysrq" = 1;

        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
        "kernel.yama.ptrace_scope" = 1;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;

        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
      };

      blacklistedKernelModules = blockedModules;
      extraModprobeConfig = ''
        options snd_hda_intel power_save=10 power_save_controller=Y
        ${lib.concatMapStringsSep "\n" (m: "install ${m} ${pkgs.coreutils}/bin/false") blockedModules}
      '';

      plymouth.enable = true;
    };

    systemd = {
      settings.Manager.DefaultTimeoutStopSec = "45s";

      services.emergency.overrideStrategy = "asDropin";
      services.rescue.overrideStrategy = "asDropin";
    };
  };
}
