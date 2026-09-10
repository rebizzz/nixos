_: {
  flake.modules.nixos.persistence = {pkgs, ...}: {
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
            "/var/lib/AccountsService"
            "/var/lib/smartmontools"
            {
              directory = "/var/lib/noctalia-greeter";
              user = "greeter";
              group = "greeter";
              mode = "0750";
            }
            "/etc/NetworkManager/system-connections"
            "/var/lib/NetworkManager"
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
          settings.Journal = {
            Storage = "persistent";
            SystemMaxFiles = 5;
            SystemMaxUse = "50M";
          };
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

      # nixpkgs' btrfs module only ships autoScrub, no equivalent for balance
      systemd.services.btrfs-balance-persistent = {
        description = "Btrfs balance on /persistent";
        serviceConfig = {
          Type = "oneshot";
          Nice = 19;
          IOSchedulingClass = "idle";
          ExecStart = "${pkgs.btrfs-progs}/bin/btrfs balance start -dusage=20 -musage=20 /persistent";
        };
      };

      systemd.timers.btrfs-balance-persistent = {
        description = "Quarterly btrfs balance on /persistent";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = "quarterly";
          Persistent = true;
          RandomizedDelaySec = "1h";
        };
      };
    };
}
