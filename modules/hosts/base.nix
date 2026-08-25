{inputs, ...}: {
  flake.modules.nixos.base = {
    pkgs,
    lib,
    ...
  }: {
    options.myConfig.hostClass = lib.mkOption {
      type = lib.types.enum ["desktop" "server"];
      description = "Whether this host is a desktop or a headless server. Selects the per-class branch of shared modules that intentionally differ by host class (power, services, persistence).";
    };

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
