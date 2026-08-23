{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
      };
    };

    services.udev.packages = [pkgs.game-devices-udev-rules];

    environment.systemPackages = with pkgs; [
      lutris
      protonplus
    ];
  };
}
