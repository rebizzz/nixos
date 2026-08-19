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
                    "@" = {
                      mountpoint = "/";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@home" = {
                      mountpoint = "/home";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@persistent" = {
                      mountpoint = "/persistent";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@tmp" = {
                      mountpoint = "/tmp";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = ["compress=zstd" "noatime"];
                    };
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
          compression = "zstd";
          acltype = "posixacl";
          xattr = "sa";
          dnodesize = "auto";
          atime = "off";
        };
        datasets = {
          "media" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/media";
            mountOptions = ["nofail"];
            options = {
              recordsize = "1M";
            };
          };
          "backup" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/backup";
            mountOptions = ["nofail"];
          };
          "storage" = {
            type = "zfs_fs";
            mountpoint = "/mnt/data/storage";
            mountOptions = ["nofail"];
          };
        };
      };
    };
  };
}
