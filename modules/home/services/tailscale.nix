_: {
  # System daemon (must run as root). Laptop is a client: it can use
  # exit nodes / subnet routes, but does not advertise any itself.
  # Change to "server" / "both" if this machine should be an exit node.
  flake.modules.nixos.tailscale = {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      # Opens 41641/udp via networking.firewall; harmless with firewalld
      # (real rule below), kept so a plain-iptables host still works.
      openFirewall = true;
    };

    # This repo uses firewalld (see modules/system/network/firewall.nix),
    # so trust the tailnet interface explicitly. Without this, tailscale0
    # falls into DefaultZone=public and peer traffic gets dropped.
    services.firewalld.zones.trusted.interfaces = ["tailscale0"];

    # State in /var/lib/tailscale is already preserved
    # (see modules/system/services/persistence.nix) so login survives
    # reboots on the ephemeral root. After rebuild: `sudo tailscale up`.
  };

  # User side: puts the `tailscale` CLI on PATH for `fish`/scripts.
  # The daemon above already ships the binary system-wide, so this is
  # just so `tailscale status` works in the user env without extra steps.
  # Usage after `just switch`: `tailscale status`, `sudo tailscale up`.
  flake.modules.homeManager.tailscale = {pkgs, ...}: {
    home.packages = [pkgs.tailscale];
  };
}
