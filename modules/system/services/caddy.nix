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
          "http://nixos-server.local, http://localhost, :80" = {
            extraConfig = ''
              # Clean redirects
              redir /sonarr /sonarr/
              redir /radarr /radarr/
              redir /prowlarr /prowlarr/
              redir /bazarr /bazarr/
              redir /jellyfin /web/index.html
              redir /transmission /transmission/web/

              # Service reverse proxies
              handle_path /jellyfin* {
                reverse_proxy 127.0.0.1:8096
              }

              handle /web* {
                reverse_proxy 127.0.0.1:8096
              }

              handle /socket* {
                reverse_proxy 127.0.0.1:8096
              }

              handle /sonarr* {
                reverse_proxy 127.0.0.1:8989
              }

              handle /radarr* {
                reverse_proxy 127.0.0.1:7878
              }

              handle /prowlarr* {
                reverse_proxy 127.0.0.1:9696
              }

              handle /transmission* {
                reverse_proxy 127.0.0.1:9091
              }

              handle /bazarr* {
                reverse_proxy 127.0.0.1:6767
              }

              handle /cockpit* {
                reverse_proxy https://127.0.0.1:9090 {
                  transport http {
                    tls_insecure_skip_verify
                  }
                }
              }

              # Default dashboard
              handle {
                respond <<HTML
                <!DOCTYPE html>
                <html lang="en">
                <head>
                  <meta charset="UTF-8">
                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                  <title>Home Server</title>
                  <style>
                    * { box-sizing: border-box; margin: 0; padding: 0; }
                    body {
                      font-family: -apple-system, BlinkMacSystemFont, 'Inter', 'Segoe UI', sans-serif;
                      background-color: #0f1015;
                      color: #e2e2ea;
                      display: flex;
                      justify-content: center;
                      align-items: center;
                      min-height: 100vh;
                      padding: 20px;
                    }
                    .container {
                      max-width: 780px;
                      width: 100%;
                    }
                    h1 {
                      font-size: 2rem;
                      margin-bottom: 8px;
                      font-weight: 700;
                      color: #b1c5ff;
                    }
                    p.sub {
                      color: #8c8f9f;
                      margin-bottom: 28px;
                      font-size: 0.95rem;
                    }
                    .grid {
                      display: grid;
                      grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                      gap: 16px;
                    }
                    .card {
                      background: #181920;
                      border: 1px solid #282a36;
                      border-radius: 12px;
                      padding: 20px;
                      text-decoration: none;
                      color: inherit;
                      transition: all 0.2s ease;
                      display: flex;
                      flex-direction: column;
                    }
                    .card:hover {
                      border-color: #b1c5ff;
                      transform: translateY(-2px);
                      background: #1f202b;
                    }
                    .title {
                      font-size: 1.15rem;
                      font-weight: 600;
                      color: #ffffff;
                      margin-bottom: 6px;
                    }
                    .desc {
                      font-size: 0.85rem;
                      color: #9da1b4;
                      line-height: 1.4;
                    }
                  </style>
                </head>
                <body>
                  <div class="container">
                    <h1>Server Portal</h1>
                    <p class="sub">nixos-server.local &bull; All services online</p>
                    <div class="grid">
                      <a class="card" href="/jellyfin">
                        <span class="title">🎬 Jellyfin</span>
                        <span class="desc">Media streaming server for movies & TV</span>
                      </a>
                      <a class="card" href="/sonarr/">
                        <span class="title">📺 Sonarr</span>
                        <span class="desc">TV series collection manager</span>
                      </a>
                      <a class="card" href="/radarr/">
                        <span class="title">🍿 Radarr</span>
                        <span class="desc">Movie collection manager</span>
                      </a>
                      <a class="card" href="/prowlarr/">
                        <span class="title">🔍 Prowlarr</span>
                        <span class="desc">Indexer and tracker management</span>
                      </a>
                      <a class="card" href="/transmission/web/">
                        <span class="title">⚡ Transmission</span>
                        <span class="desc">BitTorrent download client</span>
                      </a>
                      <a class="card" href="/bazarr/">
                        <span class="title">💬 Bazarr</span>
                        <span class="desc">Subtitles manager</span>
                      </a>
                      <a class="card" href="/cockpit/">
                        <span class="title">🛠 Cockpit</span>
                        <span class="desc">Linux server administration</span>
                      </a>
                    </div>
                  </div>
                </body>
                </html>
                HTML 200
              }
            '';
          };
        };
      };

      networking.firewall.allowedTCPPorts = [80 443];
    };
}
