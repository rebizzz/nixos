{inputs, ...}: {
  flake.nixosConfigurations = rec {
    laptop = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.self.modules.nixos.base
        inputs.self.modules.nixos.audio
        inputs.self.modules.nixos.boot
        inputs.self.modules.nixos.brave-policy
        inputs.self.modules.nixos.cachyos-tuning
        inputs.self.modules.nixos.containers
        inputs.self.modules.nixos.desktop
        inputs.self.modules.nixos.display
        inputs.self.modules.nixos.fonts
        inputs.self.modules.nixos.gaming
        inputs.self.modules.nixos.gpu
        inputs.self.modules.nixos.hibernate
        inputs.self.modules.nixos.lock-before-sleep
        inputs.self.modules.nixos.nano
        inputs.self.modules.nixos.network
        inputs.self.modules.nixos.noctalia-greeter
        inputs.self.modules.nixos.persistence
        inputs.self.modules.nixos.power
        inputs.self.modules.nixos.services
        inputs.self.modules.nixos.tools
        inputs.home-manager.nixosModules.home-manager
        inputs.niri.nixosModules.niri
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
