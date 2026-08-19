{
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  conservationMode = "/sys/bus/platform/drivers/ideapad_acpi/VPC2004:00/conservation_mode";
in {
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

  systemd.services.lenovo-conservation-mode = {
    description = "lenovo battery conservation mode";
    after = ["multi-user.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "lenovo-conservation-mode" ''
        [ -f ${conservationMode} ] && echo 1 > ${conservationMode}
      '';
      RemainAfterExit = true;
    };
  };

  fileSystems."/nix".neededForBoot = true;
  fileSystems."/persistent".neededForBoot = true;
}
