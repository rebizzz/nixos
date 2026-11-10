_: {
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraSetFlags = ["--accept-dns=false"];
    };

    services.firewalld.zones.trusted.interfaces = ["tailscale0"];
  };
}
