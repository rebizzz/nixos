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
          "http://jellyfin.lan, http://jellyfin.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:8096
            '';
          };
          "http://sonarr.lan, http://sonarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:8989
            '';
          };
          "http://radarr.lan, http://radarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:7878
            '';
          };
          "http://prowlarr.lan, http://prowlarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:9696
            '';
          };
          "http://transmission.lan, http://transmission.local, http://torrents.lan, http://torrents.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:9091
            '';
          };
          "http://bazarr.lan, http://bazarr.local" = {
            extraConfig = ''
              reverse_proxy 127.0.0.1:6767
            '';
          };
          "http://cockpit.lan, http://cockpit.local" = {
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
