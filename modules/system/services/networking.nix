_: {
  flake.modules.nixos.networking = {
    config,
    pkgs,
    lib,
    hostVars,
    ...
  }: {
    networking = {
      inherit (hostVars) hostName;
      networkmanager = {
        enable = true;
        wifi = {
          powersave = false;
          backend = "wpa_supplicant";
          macAddress = "stable";
        };
        ensureProfiles = {
          environmentFiles = [config.sops.templates."network-manager.env".path];
          profiles.${hostVars.wifi.ssid} = {
            connection = {
              id = hostVars.wifi.ssid;
              type = "wifi";
              autoconnect = true;
              autoconnect-priority = 100;
            };
            wifi = {
              mode = "infrastructure";
              ssid = hostVars.wifi.ssid;
            };
            wifi-security = {
              key-mgmt = "wpa-psk";
              psk = "$WIFI_PSK";
            };
            ipv4.method = "auto";
            ipv6.method = "auto";
          };
        };
      };
      firewall = {
        enable = true;
        allowedTCPPorts = [22 9090];
        allowedUDPPorts = [5353];
        trustedInterfaces = ["tailscale0"];
        checkReversePath = "loose";
      };
    };

    sops.templates."resolved-nextdns.conf" = {
      content = let
        id = config.sops.placeholder.nextdns_profile_id;
        label = "${hostVars.hostName}-${id}";
      in ''
        [Resolve]
        DNS=45.90.28.0#${label}.dns.nextdns.io 2a07:a8c0::#${label}.dns.nextdns.io 45.90.30.0#${label}.dns.nextdns.io 2a07:a8c1::#${label}.dns.nextdns.io
      '';
      mode = "0444";
    };

    systemd.tmpfiles.rules = [
      "d /etc/systemd/resolved.conf.d 0755 root root -"
      "L+ /etc/systemd/resolved.conf.d/nextdns.conf - - - - ${config.sops.templates."resolved-nextdns.conf".path}"
    ];

    services = {
      resolved = {
        enable = true;
        settings.Resolve = {
          DNSSEC = "yes";
          Domains = "~.";
          DNSOverTLS = "opportunistic";
        };
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        publish = {
          enable = true;
          addresses = true;
          domain = true;
        };
        openFirewall = true;
      };

      openssh = {
        enable = true;
        hostKeys = [
          {
            path = "/persistent/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
          {
            path = "/persistent/etc/ssh/ssh_host_rsa_key";
            type = "rsa";
            bits = 4096;
          }
        ];
        settings = {
          PermitRootLogin = "no";
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          X11Forwarding = false;
        };
      };

      # dongle boots into CD-ROM mode (0bda:1a2b) instead of NIC mode (0bda:c820)
      udev.packages = with pkgs; [usb-modeswitch-data usb-modeswitch];
    };

    environment.etc."usb_modeswitch.d/0bda:1a2b".text = ''
      DefaultVendor=0x0bda
      DefaultProduct=0x1a2b
      TargetVendor=0x0bda
      TargetProduct=0xc820
      StandardEject=1
    '';

    environment.systemPackages = [pkgs.usb-modeswitch];

    systemd = {
      packages = [pkgs.usb-modeswitch];

      # works around nixpkgs#296450 (NM ensure-profiles autoconnect race)
      services.wifi-autoconnect = {
        description = "Ensure the wifi connection comes up (NM autoconnect workaround)";
        after = ["NetworkManager.service"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "wifi-autoconnect" ''
            is_connected() {
              connected=0
              while IFS=: read -r type state _; do
                if [ "$type" = wifi ] && [ "$state" = connected ]; then
                  connected=1
                fi
              done < <(${pkgs.networkmanager}/bin/nmcli -t -f TYPE,STATE device status)
              [ "$connected" = 1 ]
            }
            for _ in $(seq 1 30); do
              is_connected && exit 0
              ${pkgs.networkmanager}/bin/nmcli connection up ${lib.escapeShellArg hostVars.wifi.ssid} >/dev/null 2>&1 || true
              is_connected && exit 0
              sleep 1
            done
          '';
        };
      };

      timers.wifi-autoconnect = {
        description = "Periodically ensure the wifi connection is up";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnBootSec = "1s";
          OnUnitActiveSec = "1min";
          Unit = "wifi-autoconnect.service";
        };
      };
    };
  };
}
