_: {
  # optional, opt-in per host: http://nixos-server.local:8096
  flake.modules.nixos.media = {pkgs, ...}: {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
      ];
    };

    environment.sessionVariables.LIBVA_DRIVER_NAME = "i965";
    systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965";

    users.users.jellyfin.extraGroups = ["video" "render"];

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/jellyfin"
      "/var/cache/jellyfin"
    ];
  };
}
