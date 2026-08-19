_: {
  flake.modules.homeManager.caelestia = {config, ...}: let
    homeDir = config.home.homeDirectory;
    wallpapersDir = "${homeDir}/Pictures/Wallpapers";
    wallpaperAsset = ../../../assets/wallpaper.jpg;
  in {
    programs.caelestia = {
      enable = true;
      systemd.enable = true;

      cli.enable = true;

      settings = {
        paths.wallpaperDir = wallpapersDir;
      };
    };

    home.file = {
      "Pictures/Wallpapers/default.jpg".source = wallpaperAsset;
      "Pictures/Screenshots/.keep".text = "";
    };
  };
}
