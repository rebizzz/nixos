{inputs, ...}: {
  flake.nixosConfigurations = rec {
    laptop = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.self.modules.nixos.laptop-profile
        inputs.home-manager.nixosModules.home-manager
        ./_disko.nix
        ./_hardware.nix
        ({config, ...}: {
          networking.hostName = "nixos";
          environment.etc."nixos-profile".text = "laptop";

          host.disk.device = "/dev/nvme0n1";
          boot.resumeDevice = "/dev/pool/swap";

          system.stateVersion = "26.11";

          users.users.${config.myConfig.user.name}.hashedPasswordFile = config.sops.secrets.user_password_laptop.path;

          home-manager = {
            extraSpecialArgs = {inherit inputs;};
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${config.myConfig.user.name} = inputs.self.modules.homeManager.default;
            backupFileExtension = "bak";
          };
        })
      ];
    };
    nixos = laptop;
  };
}
