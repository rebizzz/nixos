_: {
  flake.modules.nixos.zfs = _: {
    boot.zfs = {
      extraPools = ["data"];
      forceImportRoot = false;
    };

    services = {
      zfs = {
        autoScrub = {
          enable = true;
          interval = "Sun *-*-01..07 02:00:00";
          pools = ["data"];
        };
        trim.enable = false;
        zed.settings = {
          ZED_NOTIFY_DATA = true;
          ZED_NOTIFY_VERBOSE = false;
          ZED_SCRUB_AFTER_RESILVER = true;
        };
      };

      btrfs.autoScrub = {
        enable = true;
        interval = "*-*-15 03:00:00";
        fileSystems = ["/"];
      };

      sanoid = {
        enable = true;
        datasets."data" = {
          useTemplate = ["production"];
          recursive = true;
        };
        templates.production = {
          frequently = 0;
          hourly = 24;
          daily = 7;
          monthly = 3;
          yearly = 0;
          autosnap = true;
          autoprune = true;
        };
      };
    };
  };
}
