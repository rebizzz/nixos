_: {
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraSetFlags = ["--accept-dns=false"];
      openFirewall = true;
    };

    services.firewalld.zones.trusted.interfaces = ["tailscale0"];
  };

  flake.modules.homeManager.tailscale = {pkgs, ...}: {
    home.packages = [pkgs.tailscale];
  };
}
