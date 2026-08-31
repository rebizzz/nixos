_: {
  flake.modules.nixos.podman = {pkgs, ...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = ["-a"];
      };
    };

    environment.systemPackages = [
      pkgs.podman-compose
    ];
  };
}
