_: {
  flake.modules.nixos.virtualisation = {
    config,
    pkgs,
    ...
  }: {
    environment.systemPackages = [pkgs.gnome-boxes];

    virtualisation = {
      libvirtd = {
        enable = true;
        onBoot = "ignore";
        onShutdown = "shutdown";
        qemu = {
          package = pkgs.qemu_kvm;
        };
      };
    };

    users.users.${config.myConfig.user.name}.extraGroups = [
      "libvirtd"
      "kvm"
    ];
  };
}
