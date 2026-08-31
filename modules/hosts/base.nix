{inputs, ...}: {
  flake.modules.nixos.base = {pkgs, ...}: {

    imports = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      inputs.self.modules.nixos.nix
      inputs.self.modules.nixos.secrets
      inputs.self.modules.nixos.user
    ];

    config = {
      systemd.enableEmergencyMode = false;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      environment.systemPackages = [pkgs.btop];
    };
  };
}
