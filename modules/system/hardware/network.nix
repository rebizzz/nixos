_: {
  flake.modules.nixos.network = {config, ...}: {
    networking = {
      networkmanager = {
        enable = true;
        dns = "systemd-resolved";
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
            ipv4 = {
              method = "auto";
              ignore-auto-dns = true;
              dhcp-ipv6-only-preferred = true; # RFC 8925 IPv6-mostly support (Fedora 45 default)
            };
            ipv6 = {
              addr-gen-mode = "stable-privacy";
              method = "auto";
              ignore-auto-dns = true;
            };
          };
        };
      };

      nftables.enable = true;
      firewall.enable = false;
    };

    sops.templates."resolved-nextdns.conf" = {
      content = let
        id = config.sops.placeholder.nextdns_profile_id;
        label = "NixOS-${id}";
      in ''
        [Resolve]
        DNS=45.90.28.0#${label}.dns.nextdns.io 2a07:a8c0::#${label}.dns.nextdns.io 45.90.30.0#${label}.dns.nextdns.io 2a07:a8c1::#${label}.dns.nextdns.io
        Domains=~.
      '';
      mode = "0444";
      restartUnits = ["systemd-resolved.service"];
    };

    systemd.tmpfiles.rules = [
      "d /etc/systemd/resolved.conf.d 0755 root root -"
      "L+ /etc/systemd/resolved.conf.d/nextdns.conf - - - - ${config.sops.templates."resolved-nextdns.conf".path}"
    ];

    systemd.services.systemd-resolved = {
      wants = ["sops-install-secrets.service"];
      after = ["sops-install-secrets.service"];
    };

    services = {
      firewalld = {
        enable = true;
        settings = {
          DefaultZone = "FedoraWorkstation";
          FirewallBackend = "nftables";
          IPv6_rpfilter = "yes";
          LogDenied = "off";
          NftablesCounters = "yes";
          NftablesTableOwner = "yes";
        };
        zones = {
          FedoraWorkstation = {
            short = "Fedora Workstation";
            description = "Fedora Workstation default firewall zone with mDNS, DHCPv6 client, and desktop port ranges.";
            target = "default";
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
            target = "default";
            services = [
              "dhcpv6-client"
              "mdns"
              "ssh"
            ];
          };
        };
      };

      resolved = {
        enable = true;
        settings.Resolve = {
          DNSSEC = "allow-downgrade";
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
