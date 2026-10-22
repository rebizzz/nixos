_: {
  flake.modules.homeManager.mpv = {pkgs, ...}: {
    programs.mpv = {
      enable = true;

      scripts = with pkgs.mpvScripts; [
        uosc
        thumbfast
        autoload
        mpris
        evafast
        chapterskip
      ];

      config = {
        # Required for uosc (disables default mpv UI so uosc takes over)
        osc = false;
        osd-bar = false;
        border = false;

        # Video & performance
        hwdec = "auto-safe";
        vo = "gpu-next";

        # Audio
        volume = 100;
        volume-max = 150;

        # Subtitles
        sub-auto = "fuzzy";

        # Screenshots
        screenshot-directory = "~/Pictures";
        screenshot-format = "png";
        screenshot-template = "mpv-%F-%P";
      };
    };
  };
}
