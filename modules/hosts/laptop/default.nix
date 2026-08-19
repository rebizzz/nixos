{inputs, ...}: let
  excludedModules = [
    "base"
    "nix"
    "secrets"
    "user"
    "autoupgrade"
    "zfs"
    "containers"
    "media"
    "motd"
    "networking"
    "security"
    "persistence-server"
    "power-server"
    "services-server"
  ];
in {
  flake.nixosConfigurations = rec {
    laptop = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules =
        [
          inputs.self.modules.nixos.base
          inputs.home-manager.nixosModules.home-manager
          {nixpkgs.overlays = [inputs.niri.overlays.niri];}
          inputs.niri.nixosModules.niri
        ]
        ++ builtins.attrValues (builtins.removeAttrs inputs.self.modules.nixos excludedModules)
        ++ [
          ./_disko.nix
          ./_hardware.nix
          ({config, ...}: {
            networking.hostName = "nixos";
            environment.etc."nixos-profile".text = "laptop";

            host.disk.device = "/dev/nvme0n1";
            boot.resumeDevice = "/dev/pool/swap";

            system.stateVersion = "26.11";

            users.users.rebiz.hashedPasswordFile = config.sops.secrets.user_password_laptop.path;

            home-manager = {
              extraSpecialArgs = {inherit inputs;};
              useGlobalPkgs = true;
              useUserPackages = true;
              users.rebiz = inputs.self.modules.homeManager.default;
              backupFileExtension = "bak";
              sharedModules = [
                inputs.noctalia.homeModules.default
              ];
            };
          })
        ];
    };
    nixos = laptop;
  };
}
