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
      "i915.enable_fbc=1"
    ];
    blacklistedKernelModules = [
      "ahci"
      "xe"
      "sr_mod"
      "st"
      "mac_hid"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
