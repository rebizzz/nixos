{inputs, ...}: {
  flake.modules.nixos.server-profile = {
    imports = with inputs.self.modules.nixos; [
      base
      autoupgrade
      zfs
      containers
      motd
      networking
      security
      persistence
      power
      services
      # Jellyfin is opt-in: add `media` to this list to enable media serving
      # on this host.
      # Media/arr stack (nixarr: Jellyfin, Sonarr, Radarr, Prowlarr, Bazarr,
      # Transmission, Recyclarr) is opt-in: add `nixarr` to this list to
      # enable, then add indexers in Prowlarr (ports 8096/8989/7878/9696/9091).
    ];
  };
}
