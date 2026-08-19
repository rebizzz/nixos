{inputs, ...}: {
  flake.modules.nixos.containers = {pkgs, ...}: {
    imports = [inputs.self.modules.nixos.podman-base];

    virtualisation.podman.autoPrune = {
      enable = true;
      dates = "weekly";
      flags = ["-a"];
    };

    environment.systemPackages = [
      pkgs.podman-compose
    ];
  };
}
