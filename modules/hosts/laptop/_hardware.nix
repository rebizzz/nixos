{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "vmd"
        "ahci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = ["i915"];
    };
    kernelModules = ["kvm-intel"];
    kernelParams = [
      "intel_iommu=on"
      "iommu=pt"

      "i915.enable_guc=3"
      "i915.enable_psr=2"
      "i915.enable_psr2_sel_fetch=1"
      "i915.enable_fbc=1"
      "i915.fastboot=1"
    ];
    blacklistedKernelModules = [
      "xe"
      "sr_mod"
      "st"
      "mac_hid"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    intel-compute-runtime
  ];

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
