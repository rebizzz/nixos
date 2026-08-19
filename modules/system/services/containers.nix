_: {
  flake.modules.nixos.containers = {pkgs, ...}: {
    virtualisation.docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["-a"];
      };
    };

    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
