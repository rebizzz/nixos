_: {
  flake.modules.nixos.caddy = {
    config,
    lib,
    ...
  }:
    lib.mkIf (config.myConfig.hostClass == "server") {
      services.caddy = {
        enable = true;
        virtualHosts = {
          "http://jellyfin.nixos-server.local, http://jellyfin.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:8096
            '';
          };
          "http://sonarr.nixos-server.local, http://sonarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:8989
            '';
          };
          "http://radarr.nixos-server.local, http://radarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:7878
            '';
          };
          "http://prowlarr.nixos-server.local, http://prowlarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:9696
            '';
          };
          "http://transmission.nixos-server.local, http://transmission.local, http://torrents.nixos-server.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:9091
            '';
          };
          "http://bazarr.nixos-server.local, http://bazarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:6767
            '';
          };
          "http://cockpit.nixos-server.local, http://cockpit.local" = {
            extraConfig = ''
              reverse_proxy https://127.0.0.1:9090 {
                transport http {
                  tls_insecure_skip_verify
                }
              }
            '';
          };
        };
      };

      networking.firewall.allowedTCPPorts = [80 443];
    };
}
