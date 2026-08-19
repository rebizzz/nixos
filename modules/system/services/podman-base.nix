_: {
  flake.modules.nixos.podman-base = _: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
