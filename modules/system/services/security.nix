_: {
  flake.modules.nixos.security = _: {
    services.fail2ban = {
      enable = true;
      maxretry = 5;
      bantime = "1h";
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "48h";
      };
      ignoreIP = [
        "127.0.0.1/8"
        "::1"
        "10.42.0.0/24"
      ];
      jails = {
        sshd.settings = {
          enabled = true;
          port = "22";
          filter = "sshd";
          backend = "systemd";
          maxretry = 3;
          findtime = "10m";
          bantime = "2h";
        };
        cockpit.settings = {
          enabled = true;
          port = "9090";
          filter = "cockpit";
          backend = "systemd";
          maxretry = 3;
          findtime = "10m";
          bantime = "2h";
        };
      };
    };

    environment.etc."fail2ban/filter.d/cockpit.conf".text = ''
      [Definition]
      failregex = ^.*cockpit-tls.*: pam_unix\(cockpit:auth\): authentication failure; logname= uid=.* ruser=.* rhost=<HOST>.*$
                  ^.*cockpit-ws.*: pam_unix\(cockpit:auth\): authentication failure; logname= uid=.* ruser=.* rhost=<HOST>.*$
                  ^.*cockpit-session.*: pam_unix\(cockpit:auth\): authentication failure; logname= uid=.* ruser=.* rhost=<HOST>.*$
                  ^.*cockpit-ws.*: Login failed: <HOST>.*$
      ignoreregex =
    '';

    boot.kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_fin_timeout" = 15;
      "net.ipv4.tcp_syncookies" = 1;
      "net.ipv4.tcp_rfc1337" = 1;
      "net.ipv4.tcp_slow_start_after_idle" = 0;

      "net.core.rmem_max" = 16777216;
      "net.core.wmem_max" = 16777216;
      "net.core.netdev_max_backlog" = 10000;
      "net.core.somaxconn" = 4096;
      "net.ipv4.tcp_rmem" = "4096 87380 16777216";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";

      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
      "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
      "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
      "net.ipv4.conf.all.accept_redirects" = 0;
      "net.ipv4.conf.all.send_redirects" = 0;
      "net.ipv4.conf.all.accept_source_route" = 0;
      "net.ipv6.conf.all.accept_redirects" = 0;
      "net.ipv6.conf.all.accept_source_route" = 0;

      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;

      "vm.dirty_background_bytes" = 67108864; # 64 MiB
      "vm.dirty_bytes" = 268435456; # 256 MiB
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 1500;

      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
      "kernel.sysrq" = 1;
      "vm.panic_on_oom" = 0;

      "kernel.dmesg_restrict" = 1;
      "kernel.kptr_restrict" = 2;
      "kernel.unprivileged_bpf_disabled" = 1;
      "net.core.bpf_jit_harden" = 2;
      "fs.protected_hardlinks" = 1;
      "fs.protected_symlinks" = 1;
      "fs.protected_fifos" = 2;
      "fs.protected_regular" = 2;
      "fs.file-max" = 2097152;
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 1024;
    };

    systemd.services.sshd.serviceConfig.OOMScoreAdjust = -1000;

    systemd.settings.Manager = {
      DefaultLimitNOFILE = 1048576;
      DefaultLimitNPROC = 65536;
    };

    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "65536";
      }
      {
        domain = "*";
        type = "hard";
        item = "nofile";
        value = "1048576";
      }
      {
        domain = "*";
        type = "soft";
        item = "nproc";
        value = "32768";
      }
      {
        domain = "*";
        type = "hard";
        item = "nproc";
        value = "65536";
      }
    ];

    security.protectKernelImage = true;
  };
}
