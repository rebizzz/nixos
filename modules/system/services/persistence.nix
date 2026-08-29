_: {
  flake.modules.nixos.persistence = {
    config,
    lib,
    ...
  }:
    lib.mkMerge [
      (lib.mkIf (config.myConfig.hostClass == "desktop") {
        preservation = {
          enable = true;
          preserveAt."/persistent" = {
            commonMountOptions = ["x-gvfs-hide"];
            directories = [
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
              "/var/lib/systemd/timers"
              "/var/lib/systemd/backlight"
              "/var/lib/systemd/rfkill"
              "/var/lib/bluetooth"
              "/var/lib/smartmontools"
              "/var/cache/plocate"
              "/var/lib/greetd"
              "/etc/NetworkManager/system-connections"
              "/var/lib/NetworkManager"
              "/var/lib/iwd"
              "/var/lib/AccountsService"
              "/var/log/journal"
              "/var/lib/tailscale"
              {
                directory = "/var/lib/chrony";
                user = "chrony";
                group = "chrony";
                mode = "0750";
              }
            ];
            files = [
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
            ];
          };
        };

        systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

        services = {
          journald = {
            storage = "persistent";
            extraConfig = ''
              SystemMaxFiles=5
              SystemMaxUse=50M
            '';
          };

          fstrim = {
            enable = true;
            interval = "weekly";
          };

          btrfs.autoScrub = {
            enable = true;
            interval = "monthly";
            fileSystems = ["/persistent"];
          };
        };
      })
      (lib.mkIf (config.myConfig.hostClass == "server") {
        preservation = {
          enable = true;
          preserveAt."/persistent" = {
            commonMountOptions = ["x-gvfs-hide"];
            directories = [
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
              {
                directory = "/root";
                mode = "0700";
              }

              "/var/lib/systemd/timers"
              "/var/lib/systemd/timesync"
              "/var/lib/systemd/rfkill"
              "/var/log/journal"

              "/var/lib/NetworkManager"
              {
                directory = "/etc/NetworkManager/system-connections";
                mode = "0700";
              }
              {
                directory = "/var/lib/tailscale";
                mode = "0700";
              }
              "/var/lib/bluetooth"

              "/var/lib/cockpit"
              "/etc/cockpit"
              "/var/lib/smartmontools"
              "/var/lib/containers"
              "/var/lib/fail2ban"
            ];
            files = [
              {
                file = "/etc/machine-id";
                inInitrd = true;
              }
              "/etc/adjtime"
              {
                file = "/etc/zfs/zpool.cache";
                inInitrd = true;
              }
            ];
          };
        };

        systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];

        services.journald = {
          storage = "persistent";
          extraConfig = ''
            SystemMaxUse=500M
            SystemKeepFree=1G
            SystemMaxFileSize=50M
            SystemMaxFiles=50
            RuntimeMaxUse=100M
            RuntimeKeepFree=200M
            RuntimeMaxFileSize=20M
            MaxRetentionSec=1month
            RateLimitIntervalSec=30s
            RateLimitBurst=10000
          '';
        };

        fileSystems."/persistent".neededForBoot = true;
        fileSystems."/nix".neededForBoot = true;
      })
    ];
}
