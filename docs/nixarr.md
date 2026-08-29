# Nixarr Media Server Stack Setup & Architecture Guide

A fully declarative, zero-touch media automation stack deployed on `nixos-server` ("Fern") using [Nixarr](https://github.com/rasmus-kirk/nixarr), [Caddy](https://caddyserver.com/), and native NixOS services.

---

## 1. Overview & Architecture

The stack runs entirely on `nixos-server` behind a reverse proxy with automated indexer sync, download handling, metadata scraping, subtitle management, and Cloudflare challenge bypassing.

```mermaid
graph TD
    Client["User Devices (Browser / TV / Phone)"] -->|Port 80 / 443| Caddy["Caddy Reverse Proxy"]
    Client -->|Port 8096 (Direct)| Jellyfin["Jellyfin Media Server"]

    subgraph Management ["Automation & Indexers"]
        Caddy -->|/sonarr/| Sonarr["Sonarr (TV Shows)"]
        Caddy -->|/radarr/| Radarr["Radarr (Movies)"]
        Caddy -->|/prowlarr/| Prowlarr["Prowlarr (Indexer Hub)"]
        Caddy -->|/bazarr/| Bazarr["Bazarr (Subtitles)"]
        Caddy -->|/transmission/| Transmission["Transmission (BitTorrent)"]
        Caddy -->|/cockpit/| Cockpit["Cockpit (Server Dashboard)"]
        Caddy -->|/ (Default)| Portal["Server Portal"]
    end

    subgraph CloudflareBypass ["Cloudflare Solving"]
        Prowlarr -->|Port 8191| FlareSolverr["FlareSolverr (Headless Chromium)"]
    end

    subgraph SyncEngine ["Automated Inter-Service Sync"]
        Prowlarr -.->|Auto-sync Indexers| Sonarr
        Prowlarr -.->|Auto-sync Indexers| Radarr
        Sonarr -.->|Send Torrents| Transmission
        Radarr -.->|Send Torrents| Transmission
        Sonarr -.->|Link TV| Bazarr
        Radarr -.->|Link Movies| Bazarr
        Recyclarr["Recyclarr"] -.->|Sync TRaSH Guides| Sonarr
        Recyclarr -.->|Sync TRaSH Guides| Radarr
    end

    subgraph Storage ["ZFS Pool (/mnt/data)"]
        Transmission -->|Downloads| Torrents["/mnt/data/media/torrents/"]
        Sonarr -->|Hardlink / Move| Shows["/mnt/data/media/library/shows/"]
        Radarr -->|Hardlink / Move| Movies["/mnt/data/media/library/movies/"]
        Jellyfin -->|Stream| Shows
        Jellyfin -->|Stream| Movies
    end
```

---

## 2. Directory Layout & Storage

All persistent data and media reside under the ZFS pool at `/mnt/data`:

```
/mnt/data/
├── media/
│   ├── library/               # Processed media for Jellyfin
│   │   ├── movies/            # Radarr root folder
│   │   ├── shows/             # Sonarr root folder
│   │   ├── music/
│   │   ├── books/
│   │   └── audiobooks/
│   └── torrents/              # Active & completed downloads
│       ├── tv-sonarr/         # Sonarr download directory
│       ├── movies-radarr/     # Radarr download directory
│       ├── sonarr/
│       ├── radarr/
│       ├── .incomplete/       # In-progress torrent chunks
│       └── .watch/            # Auto-load .torrent files
└── storage/
    └── .state/nixarr/         # SQLite databases & persistent app configs
        ├── sonarr/
        ├── radarr/
        ├── prowlarr/
        ├── jellyfin/
        ├── transmission/
        ├── bazarr/
        └── secrets/           # Extracted API keys (*.api-key)
```

### Declarative Permissions
The entire directory tree is declaratively managed via `systemd.tmpfiles.rules` with mode `2775` (`drwxrwsr-x`) and `setgid` owned by `:media`. This guarantees that `transmission`, `sonarr`, `radarr`, and `jellyfin` always have shared read/write access to newly downloaded files without permission collisions.

---

## 3. URLs & Service Endpoints

All services are accessible on your local network on port `80` (no port numbers required):

| Service | Local URL | Port (Backend) | Purpose |
| :--- | :--- | :--- | :--- |
| **Server Portal** | **`http://nixos-server.local/`** | `80` | Unified web landing page |
| **Jellyfin** | **`http://nixos-server.local/web/`** | `8096` | Streaming Movies & TV |
| **Sonarr** | **`http://nixos-server.local/sonarr/`** | `8989` | TV Series automation |
| **Radarr** | **`http://nixos-server.local/radarr/`** | `7878` | Movie automation |
| **Prowlarr** | **`http://nixos-server.local/prowlarr/`** | `9696` | Indexers & trackers manager |
| **Transmission** | **`http://nixos-server.local/transmission/web/`** | `9091` | Torrent client |
| **Bazarr** | **`http://nixos-server.local/bazarr/`** | `6767` | Subtitle downloader |
| **Cockpit** | **`http://nixos-server.local/cockpit/`** | `9090` | Linux server management |
| **FlareSolverr** | *Internal only (`127.0.0.1:8191`)* | `8191` | Cloudflare captcha solver |

---

## 4. Automated 1-Deploy Features

The configuration in [`modules/system/services/nixarr.nix`](../modules/system/services/nixarr.nix) contains complete zero-touch automation:

1. **Pre-Configuration Hook (`nixarr-preconfigure.service`)**:
   - Injects `<UrlBase>/sonarr</UrlBase>`, `<UrlBase>/radarr</UrlBase>`, and `<UrlBase>/prowlarr</UrlBase>` before the services start for the first time.
   - Sets `<AuthenticationRequired>DisabledForLocalAddresses</AuthenticationRequired>` so LAN clients can connect seamlessly without login prompts.
2. **Self-Healing Sync Units**:
   - `sonarr-sync-config`, `radarr-sync-config`, `prowlarr-sync-config`, and `bazarr-sync-config` have `Restart = "on-failure"` with a 5-second backoff and 120-second timeout, completely eliminating first-boot race conditions.
3. **Transmission Integration**:
   - Configured with `umask = 2` for group write access.
   - Disabled `rpc-host-whitelist` to allow clean reverse proxying via Caddy.
4. **Native FlareSolverr**:
   - Deployed as a native systemd daemon running headless Chromium on `127.0.0.1:8191`.

---

## 5. Initial Configuration Checklist (One-Time Setup)

Once deployed, perform these quick setup steps in your browser:

### 1. Jellyfin Setup
1. Open **`http://nixos-server.local/web/index.html#!/wizardstart.html`**.
2. Create your admin username and password.
3. Add your media libraries:
   - **Movies**: `/mnt/data/media/library/movies`
   - **TV Shows**: `/mnt/data/media/library/shows`
4. Finish the wizard.

### 2. Sonarr & Radarr Root Folders
1. In **Sonarr** (`http://nixos-server.local/sonarr/`):
   - Navigate to **Settings** -> **Media Management** -> **Root Folders**.
   - Click **Add Root Folder** and select `/mnt/data/media/library/shows`.
2. In **Radarr** (`http://nixos-server.local/radarr/`):
   - Navigate to **Settings** -> **Media Management** -> **Root Folders**.
   - Click **Add Root Folder** and select `/mnt/data/media/library/movies`.

### 3. Prowlarr FlareSolverr Proxy & Indexers
1. Open **Prowlarr** (`http://nixos-server.local/prowlarr/`).
2. Go to **Settings** -> **Indexers** -> click **`+`** under **Proxies** -> select **FlareSolverr**.
   - **Name**: `FlareSolverr`
   - **Host**: `http://localhost:8191`
   - **Tags**: `flaresolverr` *(or leave blank for all indexers)*
   - Click **Test** and **Save**.
3. Go to **Indexers** -> click **Add Indexer** to add your favorite trackers (e.g. 1337x, TorrentGalaxy, YTS, EZTV).
4. Prowlarr will automatically sync all added indexers into Sonarr and Radarr.

---

## 6. Maintenance & Useful Commands

### Deploy Updates to Server
```bash
just server-apply
```

### Check Service Health
```bash
ssh rebiz@nixos-server.local "systemctl status caddy jellyfin sonarr radarr prowlarr transmission bazarr flaresolverr"
```

### View Live Logs
```bash
# FlareSolverr challenge logs
ssh rebiz@nixos-server.local "journalctl -u flaresolverr.service -f"

# Sync configuration logs
ssh rebiz@nixos-server.local "journalctl -u sonarr-sync-config -u radarr-sync-config -u prowlarr-sync-config -f"

# Caddy access logs
ssh rebiz@nixos-server.local "journalctl -u caddy.service -f"
```
