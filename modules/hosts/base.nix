{inputs, ...}: {
  flake.modules.nixos.base = {config, ...}: {
    imports = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ] ++ (builtins.attrValues (builtins.removeAttrs inputs.self.modules.nixos ["base"]));

    system.stateVersion = "26.11";

    home-manager = {
      extraSpecialArgs = {inherit inputs;};
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${config.myConfig.user.name} = inputs.self.modules.homeManager.default;
      backupFileExtension = "bak";
      sharedModules = [
        inputs.caelestia-shell.homeManagerModules.default
      ];
    };
  };
}
