{
  hostVars,
  lib,
  ...
}: let
  mirrorDisk = dev: {
    type = "disk";
    device = dev;
    content = {
      type = "gpt";
      partitions.zfs = {
        size = "100%";
        content = {
          type = "zfs";
          pool = "data";
        };
      };
    };
  };

  mirrorDisks = lib.listToAttrs (lib.imap0
    (i: dev: {
      name = "zfsMirror${builtins.toString i}";
      value = mirrorDisk dev;
    })
    hostVars.disks.zfsMirror);
  btrfsOpts = ["compress=zstd:3" "noatime" "space_cache=v2" "discard=async"];
  subvol = mountpoint: {
    inherit mountpoint;
    mountOptions = btrfsOpts;
  };
in {
  disko.devices = {
    disk =
      {
        system = {
          type = "disk";
          device = hostVars.disks.system;
          content = {
            type = "gpt";
            partitions = {
              esp = {
                priority = 1;
                name = "ESP";
                size = "1G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [
                    "fmask=0077"
                    "dmask=0077"
                  ];
                };
              };
              root = {
                size = "100%";
                content = {
                  type = "btrfs";
                  extraArgs = ["-f"];
                  subvolumes = {
                    "@blank" = {};
                    "@" = subvol "/";
                    "@home" = subvol "/home";
                    "@nix" = subvol "/nix";
                    "@persistent" = subvol "/persistent";
                    "@tmp" = subvol "/tmp";
                    "@log" = subvol "/var/log";
                  };
                };
              };
            };
          };
        };
      }
      // mirrorDisks;
    zpool = {
      data = {
        type = "zpool";
        mode = "mirror";
        mountpoint = "/mnt/data";
        mountOptions = ["nofail"];
        options = {
          ashift = "12";
        };
        rootFsOptions = {
          compression = "zstd-3";
          acltype = "posixacl";
          xattr = "sa";
          dnodesize = "auto";
          atime = "off";
          canmount = "noauto";
        };
        datasets = {
          "media" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/media";
            mountOptions = ["nofail"];
            options = {
              recordsize = "1M";
              canmount = "noauto";
            };
          };
          "backup" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/backup";
            mountOptions = ["nofail"];
            options = {
              canmount = "noauto";
            };
          };
          "storage" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/storage";
            mountOptions = ["nofail"];
            options = {
              canmount = "noauto";
            };
          };
          "shared" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/shared";
            mountOptions = ["nofail"];
            options = {
              canmount = "noauto";
            };
          };
        };
      };
    };
  };
}
