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
        osc = false;
        osd-bar = false;
        border = false;

        hwdec = "auto-safe";
        vo = "gpu-next";

        volume = 100;
        volume-max = 150;

        sub-auto = "fuzzy";

        screenshot-directory = "~/Pictures/Mpv Screenshots";
        screenshot-format = "png";
        screenshot-template = "mpv-%F-%P";
      };

      bindings = {
        "MBTN_RIGHT" = "script-binding uosc/menu";
        "menu" = "script-binding uosc/menu";

        "ctrl+o" = "script-binding uosc/open-file";
        "o" = "script-binding uosc/open-file";
        "ctrl+shift+o" = "script-binding uosc/open-file";

        "ctrl+l" = "script-binding uosc/playlist";
        "p" = "script-binding uosc/playlist";

        "s" = "script-binding uosc/subtitles";
        "S" = "script-binding uosc/load-subtitles";
        "v" = "cycle sub";

        "a" = "script-binding uosc/audio";
        "b" = "cycle audio";

        "c" = "script-binding uosc/chapters";

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
