{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs.gamemode = {
      enable = true;
      settings.general = {
        softrealtime = "off";
        renice = 0;
      };
    };
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraArgs = "-cef-disable-gpu-compositing";
      };
    };

    environment.systemPackages = with pkgs; [
      lutris
      protonplus
    ];
  };
}
