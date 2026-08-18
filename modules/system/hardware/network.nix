_: {
  flake.modules.nixos.network = {config, ...}: {
    networking = {
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
        wifi.macAddress = "random";

        ensureProfiles = {
          environmentFiles = [config.sops.templates."network-manager.env".path];
          profiles.ReBiz = {
            connection = {
              id = "ReBiz";
              type = "wifi";
            };
            wifi = {
              mode = "infrastructure";
              ssid = "ReBiz";
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_PSK";
            };
            ipv4.method = "auto";
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
            };
          };
        };
      };

      nftables.enable = true;

      firewall = {
        enable = true;
        extraInputRules = "ip6 daddr fe80::/64 udp dport 546 accept"; # dhcpv6-client
      };
    };

    services = {
      resolved = {
        enable = true;
        settings.Resolve = {
          DNS = "45.90.28.0#NixOS-d4e7df.dns.nextdns.io 2a07:a8c0::#NixOS-d4e7df.dns.nextdns.io 45.90.30.0#NixOS-d4e7df.dns.nextdns.io 2a07:a8c1::#NixOS-d4e7df.dns.nextdns.io";
          DNSSEC = "yes";
          Domains = "~.";
          DNSOverTLS = "opportunistic";
        };
      };

      chrony.enable = true;

      avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };
  };
}
