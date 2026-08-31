_: {
  flake.modules.nixos.firewall = _: {
    networking.nftables.enable = true;

    services.firewalld = {
      enable = true;
      settings = {
        DefaultZone = "FedoraWorkstation";
        NftablesCounters = true;
      };
      zones = {
        FedoraWorkstation = {
          short = "Fedora Workstation";
          description = "Fedora Workstation default firewall zone with mDNS, DHCPv6 client, and desktop port ranges.";
          services = [
            "dhcpv6-client"
            "mdns"
            "samba-client"
            "ssh"
          ];
          ports = [
            {
              port = {
                from = 1025;
                to = 65535;
              };
              protocol = "udp";
            }
            {
              port = {
                from = 1025;
                to = 65535;
              };
              protocol = "tcp";
            }
          ];
        };
        public = {
          short = "Public";
          description = "Hardened public zone accepting only essential discovery and DHCP.";
          services = [
            "dhcpv6-client"
            "mdns"
            "ssh"
          ];
        };
      };
    };
  };
}
