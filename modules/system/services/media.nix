_: {
  flake.modules.nixos.media = {pkgs, ...}: {
    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };

    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
        intel-compute-runtime
      ];
    };

    systemd.services.jellyfin.serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
    };

    users.users.jellyfin.extraGroups = ["video" "render"];

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/jellyfin"
      "/var/cache/jellyfin"
    ];
  };
}
