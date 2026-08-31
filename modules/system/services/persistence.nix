_: {
  flake.modules.nixos.persistence = _: {
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
            "/var/lib/noctalia-greeter"
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
    };
}
