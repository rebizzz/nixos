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
      # exotic network protocols
      "dccp"
      "sctp"
      "rds"
      "tipc"
      "ax25"
      "netrom"
      "rose"
      "atm"
      # legacy filesystems
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
    ];
  in {
    boot = {
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
          editor = false;
        };
        efi.canTouchEfiVariables = true;
        timeout = 3;
      };

      kernelPackages = pkgs.linuxPackages_latest;
      kernelParams = [
        "quiet"
        "splash"
        "loglevel=3"

        "rd.udev.log_level=3"
        "udev.log_level=0"
        "rd.systemd.show_status=auto"

        "init_on_alloc=1"
        "init_on_free=1"
        "page_alloc.shuffle=1"
        "randomize_kstack_offset=on"
      ];
      consoleLogLevel = 3;
      supportedFilesystems = ["ntfs" "udf"];
      tmp.cleanOnBoot = true;

      initrd.systemd.enable = true;
      initrd.verbose = false;

      kernel.sysctl = {
        "vm.swappiness" = 60;
        "vm.page-cluster" = 0;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;

        "kernel.nmi_watchdog" = 0;

        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.yama.ptrace_scope" = 1;
        "fs.protected_fifos" = 2;
        "fs.protected_regular" = 2;

        "net.core.default_qdisc" = "fq";
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.conf.default.rp_filter" = 1;
        "net.ipv4.conf.all.accept_redirects" = 0;
        "net.ipv4.conf.default.accept_redirects" = 0;
        "net.ipv4.tcp_syncookies" = 1;
        "net.ipv4.tcp_rfc1337" = 1;
      };

      blacklistedKernelModules = blockedModules;
      extraModprobeConfig = ''
        options snd_hda_intel power_save=1
        ${lib.concatMapStringsSep "\n" (m: "install ${m} ${pkgs.coreutils}/bin/false") blockedModules}
      '';

      plymouth.enable = true;
    };

    systemd.settings.Manager.DefaultTimeoutStopSec = "45s";
  };
}
