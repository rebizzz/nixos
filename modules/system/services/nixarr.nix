{inputs, ...}: {
  flake.modules.nixos.nixarr = {
    config,
    pkgs,
    lib,
    ...
  }: {
    imports = [inputs.nixarr.nixosModules.default];

    nixarr = {
      enable = true;

      mediaDir = "/mnt/data/media";
      stateDir = "/mnt/data/storage/.state/nixarr";
      mediaUsers = [config.myConfig.user.name];

      jellyfin = {
        enable = true;
        openFirewall = true;
      };

      sonarr = {
        enable = true;
        openFirewall = false;
        settings-sync.transmission.enable = true;
      };

      radarr = {
        enable = true;
        openFirewall = false;
        settings-sync.transmission.enable = true;
      };

      prowlarr = {
        enable = true;
        openFirewall = false;
        settings-sync.enable-nixarr-apps = true;
      };

      transmission = {
        enable = true;
        openFirewall = false;
        peerPort = 51413;
        extraSettings = {
          umask = 2;
        };
      };

      bazarr = {
        enable = true;
        openFirewall = false;
        settings-sync = {
          sonarr.enable = true;
          radarr.enable = true;
        };
      };

      recyclarr = {
        enable = true;
        configuration = {
          sonarr.series = {
            base_url = "http://localhost:${toString config.nixarr.sonarr.port}";
            api_key = "!env_var SONARR_API_KEY";
            quality_definition.type = "series";
          };
          radarr.movies = {
            base_url = "http://localhost:${toString config.nixarr.radarr.port}";
            api_key = "!env_var RADARR_API_KEY";
            quality_definition.type = "movie";
          };
        };
      };
    };

    networking.firewall = {
      allowedTCPPorts = [config.nixarr.transmission.peerPort];
      allowedUDPPorts = [config.nixarr.transmission.peerPort];
    };

    # Declarative directory creation & permissions on every boot/deploy
    systemd.tmpfiles.rules = [
      "d /mnt/data/media 2775 root media -"
      "d /mnt/data/media/library 2775 root media -"
      "d /mnt/data/media/library/movies 2775 root media -"
      "d /mnt/data/media/library/shows 2775 root media -"
      "d /mnt/data/media/library/music 2775 root media -"
      "d /mnt/data/media/library/books 2775 root media -"
      "d /mnt/data/media/library/audiobooks 2775 root media -"
      "d /mnt/data/media/torrents 2775 transmission media -"
      "d /mnt/data/media/torrents/sonarr 2775 transmission media -"
      "d /mnt/data/media/torrents/radarr 2775 transmission media -"
      "d /mnt/data/media/torrents/tv-sonarr 2775 transmission media -"
      "d /mnt/data/media/torrents/movies-radarr 2775 transmission media -"
      "d /mnt/data/media/torrents/tv 2775 transmission media -"
      "d /mnt/data/media/torrents/movies 2775 transmission media -"
      "d /mnt/data/media/torrents/.incomplete 2775 transmission media -"
      "d /mnt/data/media/torrents/.watch 2775 transmission media -"
      "d /mnt/data/storage/.state/nixarr 0755 root root -"
      "d /mnt/data/storage/.state/nixarr/secrets 0711 root root -"
    ];

    # Pre-configure UrlBase & Local Auth in config.xml for Sonarr, Radarr, Prowlarr
    systemd.services.nixarr-preconfigure = {
      description = "Pre-configure UrlBase and authentication for nixarr services";
      wantedBy = ["multi-user.target"];
      before = ["sonarr.service" "radarr.service" "prowlarr.service" "bazarr.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "nixarr-preconfigure" ''
                    set -euo pipefail
                    STATE_DIR="/mnt/data/storage/.state/nixarr"

                    init_config() {
                      local app="$1"
                      local user="$2"
                      local url_base="$3"
                      local conf="$STATE_DIR/$app/config.xml"

                      mkdir -p "$STATE_DIR/$app"
                      if [ ! -f "$conf" ]; then
                        cat <<CONF > "$conf"
          <Config>
            <BindAddress>*</BindAddress>
            <Port>8989</Port>
            <EnableSsl>False</EnableSsl>
            <LaunchBrowser>False</LaunchBrowser>
            <AuthenticationMethod>None</AuthenticationMethod>
            <AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>
            <Branch>main</Branch>
            <LogLevel>info</LogLevel>
            <UrlBase>/$url_base</UrlBase>
            <InstanceName>$app</InstanceName>
          </Config>
          CONF
                      else
                        # Ensure UrlBase is set
                        if ! grep -q "<UrlBase>/$url_base</UrlBase>" "$conf"; then
                          if grep -q "<UrlBase>" "$conf"; then
                            sed -i "s|<UrlBase>.*</UrlBase>|<UrlBase>/$url_base</UrlBase>|" "$conf"
                          else
                            sed -i "s|</Config>|  <UrlBase>/$url_base</UrlBase>\n</Config>|" "$conf"
                          fi
                        fi
                        # Ensure Local Auth
                        if ! grep -q "AuthenticationRequired" "$conf"; then
                          sed -i "s|</Config>|  <AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>\n</Config>|" "$conf"
                        fi
                      fi
                      chown -R "$user:media" "$STATE_DIR/$app"
                      chmod 640 "$conf" 2>/dev/null || true
                    }

                    init_config "sonarr" "sonarr" "sonarr"
                    init_config "radarr" "radarr" "radarr"
                    init_config "prowlarr" "prowlarr" "prowlarr"
        '';
      };
    };

    # Auto-retry sync services so first-boot race condition is completely self-healing
    systemd.services.sonarr-sync-config.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStartSec = "120s";
    };
    systemd.services.radarr-sync-config.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStartSec = "120s";
    };
    systemd.services.prowlarr-sync-config.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStartSec = "120s";
    };
    systemd.services.bazarr-sync-config.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
      TimeoutStartSec = "120s";
    };

    services = {
      flaresolverr = {
        enable = true;
        port = 8191;
        openFirewall = false;
      };
      sonarr.settings.auth.required = "DisabledForLocalAddresses";
      radarr.settings.auth.required = "DisabledForLocalAddresses";
      prowlarr.settings.auth.required = "DisabledForLocalAddresses";
    };
  };
}
