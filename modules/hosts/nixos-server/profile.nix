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
      nfs
      nixarr
      # Jellyfin is opt-in: add `media` to this list to enable media serving
      # on this host (nixarr includes Jellyfin).
    ];
  };
}
