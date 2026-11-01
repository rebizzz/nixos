_: {
  flake.modules.nixos.virtualisation = {
    config,
    pkgs,
    ...
  }: {
    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
      spiceUSBRedirection.enable = true;
    };

    users.users.${config.myConfig.user.name}.extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };
}
