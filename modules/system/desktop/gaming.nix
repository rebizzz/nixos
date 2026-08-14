{
  flake.modules.nixos.gaming = {pkgs, ...}: {
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
