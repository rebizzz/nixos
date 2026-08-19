{
  lib,
  pkgs,
  modulesPath,
  hostVars,
  config,
  utils,
  ...
}: let
  rootDevice = config.fileSystems."/".device;
  rootDeviceUnit = "${utils.escapeSystemdPath rootDevice}.device";
in {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      systemd.services.rollback-root = {
        description = "Roll back / to a blank btrfs snapshot";
        wantedBy = ["initrd.target"];
        after = [rootDeviceUnit];
        requires = [rootDeviceUnit];
        before = ["sysroot.mount"];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        path = [pkgs.btrfs-progs pkgs.coreutils pkgs.util-linux];
        script = ''
          mkdir -p /mnt
          mount -t btrfs -o subvol=/ ${rootDevice} /mnt
          if [ -e /mnt/@ ]; then
            btrfs subvolume list -o /mnt/@ |
              cut -f9- -d' ' |
              while read -r subvolume; do
                btrfs subvolume delete "/mnt/$subvolume" || true
              done
            btrfs subvolume delete /mnt/@
          fi
          if [ -e /mnt/@blank ]; then
            btrfs subvolume snapshot /mnt/@blank /mnt/@
          else
            btrfs subvolume create /mnt/@
          fi
          umount /mnt
        '';
      };

      availableKernelModules = [
        "ahci"
        "ehci_pci"
        "usb_storage"
        "sd_mod"
        "sr_mod"
        "r8169"
      ];
      kernelModules = [];
    };

    kernelParams = [
      "usbcore.autosuspend=-1"
      "panic=10"
      "oops=panic"
      "zfs.zfs_arc_min=536870912" # 512 MiB
      "zfs.zfs_arc_max=2147483648" # 2 GiB
      "zfs.zfs_arc_sys_free=536870912" # 512 MiB headroom
    ];

    kernelModules = [
      "kvm-intel"
      "tcp_bbr"
      "rtw88_8821cu"
      "rtw88_core"
      "rtw88_usb"
      "btusb"
      "iTCO_wdt"
    ];
    extraModulePackages = [];

    supportedFilesystems = ["btrfs" "zfs"];
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.intel.updateMicrocode = true;
    wirelessRegulatoryDatabase = true;
  };

  networking.hostId = hostVars.hostId;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
