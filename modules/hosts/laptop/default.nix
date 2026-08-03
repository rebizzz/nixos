{inputs, ...}: {
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs;};
    modules = [
      inputs.self.modules.nixos.base
      ./_disko.nix
      ./_hardware.nix
      {
        networking.hostName = "nixos";
        environment.etc."nixos-profile".text = "laptop";

        host.disk.device = "/dev/nvme0n1";
        boot.resumeDevice = "/dev/pool/swap";
      }
    ];
  };
}
