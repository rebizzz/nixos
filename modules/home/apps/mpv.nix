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
        screenshot-directory = "~/Pictures/Mpv Screenshots";
        screenshot-format = "png";
        screenshot-template = "mpv-%F-%P";
      };

      bindings = {
        # Right click & Menu (VLC / Haruna context menu)
        "MBTN_RIGHT" = "script-binding uosc/menu";
        "menu" = "script-binding uosc/menu";

        # Open file (VLC / Haruna: Ctrl+O, plus quick 'o')
        "ctrl+o" = "script-binding uosc/open-file";
        "o" = "script-binding uosc/open-file";
        "ctrl+shift+o" = "script-binding uosc/open-file";

        # Playlist (VLC: Ctrl+L, Haruna: P)
        "ctrl+l" = "script-binding uosc/playlist";
        "p" = "script-binding uosc/playlist";

        # Subtitles (VLC/Haruna: v to cycle, s for uosc menu, S to load file)
        "s" = "script-binding uosc/subtitles";
        "S" = "script-binding uosc/load-subtitles";
        "v" = "cycle sub";

        # Audio (VLC: b to cycle, a for uosc menu)
        "a" = "script-binding uosc/audio";
        "b" = "cycle audio";

        # Chapters (Haruna: C)
        "c" = "script-binding uosc/chapters";

        # Playback & volume (VLC / Haruna standard)
        "space" = "cycle pause";
        "f" = "cycle fullscreen";
        "m" = "cycle mute";
        "UP" = "add volume 2";
        "DOWN" = "add volume -2";
        "WHEEL_UP" = "add volume 2";
        "WHEEL_DOWN" = "add volume -2";
        "[" = "add speed -0.1";
        "]" = "add speed 0.1";
        "BS" = "set speed 1.0";
        "tab" = "script-binding uosc/toggle-ui";
      };
    };
  };
}
