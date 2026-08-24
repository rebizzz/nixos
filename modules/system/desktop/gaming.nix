{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
      };
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = -10;
        };
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
        };
      };
    };

    services.udev.packages = [pkgs.game-devices-udev-rules];

    environment.systemPackages = with pkgs; [
      lutris
      protonplus
    ];
  };
}
