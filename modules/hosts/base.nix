{inputs, ...}: {
  flake.modules.nixos.base = {
    imports = with inputs.self.modules.nixos; [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
      {nixpkgs.overlays = [inputs.niri.overlays.niri];}
      inputs.niri.nixosModules.niri

      boot
      nix
      user
      secrets

      audio
      display
      gpu
      network
      power

      hibernate
      lock-before-sleep
      noctalia-greeter
      services
      virtualisation

      fonts
      desktop
      gaming
      tools
      nano

      brave-policy

      persistence

      {
        system.stateVersion = "26.11";

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
      }
    ];
  };
}
