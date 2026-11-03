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

      "af_alg"
      "algif_hash"
      "algif_skcipher"
      "algif_rng"
      "algif_aead"
    ];
  in {
    boot = {
      loader = {
        grub = {
          enable = true;
          efiSupport = true;
          device = "nodev";
          configurationLimit = 10;
          extraEntries = ''
            submenu 'Brunch' {
            menuentry 'Brunch' --class 'brunch' {
            	unset theme
            	img_path="/chromeos.img"
            	img_uuid="a000f02a-85d9-4c42-b0f3-ab5539fdd4c0"
            	search --no-floppy --set=root --file ''${img_path}
            	loopback loop ''${img_path}
            	source (loop,12)/efi/boot/settings.cfg
            	if [ -z ''${verbose} ] -o [ ''${verbose} -eq 0 ]; then
            		linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
            			cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path} \
            			console= vt.global_cursor_default=0 brunch_bootsplash=''${brunch_bootsplash} quiet
            	else
            		linux (loop,7)''${kernel} boot=local noresume noswap loglevel=7 options=''${options} chromeos_bootsplash=''${chromeos_bootsplash} ''${cmdline_params} \
            			cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
            	fi
            	initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
            }
            menuentry 'Brunch settings' --class 'brunch-settings' {
            	unset theme
            	img_path="/chromeos.img"
            	img_uuid="a000f02a-85d9-4c42-b0f3-ab5539fdd4c0"
            	search --no-floppy --set=root --file ''${img_path}
            	loopback loop ''${img_path}
            	source (loop,12)/efi/boot/settings.cfg
            	linux (loop,7)/kernel boot=local noresume noswap loglevel=7 options= chromeos_bootsplash= edit_brunch_config=1 \
            		cros_secure cros_debug img_uuid=''${img_uuid} img_path=''${img_path}
            	initrd (loop,7)/lib/firmware/amd-ucode.img (loop,7)/lib/firmware/intel-ucode.img (loop,7)/initramfs.img
            }
            }
          '';
        };
        efi.canTouchEfiVariables = true;
        timeout = 5;
      };

      kernelPackages = pkgs.linuxPackages_zen;
      kernelModules = ["tcp_bbr"];
      kernelParams = [
        "quiet"
        "splash"

        "rd.udev.log_level=3"
        "udev.log_level=0"
        "rd.systemd.show_status=auto"

        "rcutree.enable_rcu_lazy=1"
      ];
      consoleLogLevel = 3;
      supportedFilesystems = ["udf" "nfs"];
      tmp.cleanOnBoot = true;

      kernel.sysctl = {
        "vm.swappiness" = 60;
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
        "kernel.unprivileged_bpf_disabled" = 1;
        "kernel.yama.ptrace_scope" = 2;
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
        options snd_hda_intel power_save=1 power_save_controller=Y
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
