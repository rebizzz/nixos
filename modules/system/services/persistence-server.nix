_: {
  flake.modules.nixos.persistence-server = _: {
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

          {
            directory = "/var/lib/docker";
            mode = "0710";
          }
          "/var/lib/cockpit"
          "/etc/cockpit"
          "/var/lib/smartmontools"
        ];
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          "/etc/adjtime"
          "/etc/zfs/zpool.cache"
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
  };
}
