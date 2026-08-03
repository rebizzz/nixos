{
  lib,
  config,
  ...
}: let
  diskCfg = config.host.disk;
  btrfsOpts = ["compress=zstd:2" "noatime"];
  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = btrfsOpts;
  };
  strOption = default:
    lib.mkOption {
      type = lib.types.str;
      inherit default;
    };
in {
  options.host.disk = {
    device = strOption "/dev/nvme0n1";
    luksName = strOption "cryptroot";
    swapSize = strOption "12G";
    espSize = strOption "1022M";
    rootTmpfsSize = strOption "25%";
  };

  config.disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=${diskCfg.rootTmpfsSize}"
        "mode=755"
        "x-gvfs-notrash"
      ];
    };

    disk.main = {
      inherit (diskCfg) device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 1;
            name = "ESP";
            start = "1M";
            end = diskCfg.espSize;
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["fmask=0022" "dmask=0022"];
            };
          };

          root = {
            size = "100%";
            content = {
              type = "luks";
              name = diskCfg.luksName;
              settings.allowDiscards = true;
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg.pool = {
      type = "lvm_vg";
      lvs = {
        swap = {
          size = diskCfg.swapSize;
          content = {type = "swap";};
        };

        root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            subvolumes = {
              "/@home" = subvol "/home";
              "/@nix" = subvol "/nix";
              "/@persistent" = subvol "/persistent";
              "/@tmp" = subvol "/tmp";
            };
          };
        };
      };
    };
  };
}
