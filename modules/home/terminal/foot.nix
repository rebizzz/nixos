_: {
  flake.modules.homeManager.foot = {
    config,
    lib,
    ...
  }: let
    themeFile = "${config.xdg.configHome}/foot/themes/noctalia";
  in {
    programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font Mono:size=13";
          pad = "8x8 center";
          term = "xterm-256color";
          include = themeFile;
        };

        mouse.hide-when-typing = "yes";

        cursor = {
          style = "block";
          blink = "no";
        };

        colors-dark.alpha = "0.85";
      };
    };

    # `include=themeFile` fails foot's config validation until noctalia has
    # rendered the template once. Noctalia overwrites this on the next apply.
    home.activation.footNoctaliaTheme = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ ! -e "${themeFile}" ]; then
        run mkdir -p $VERBOSE_ARG "$(dirname "${themeFile}")"
        run tee "${themeFile}" >/dev/null <<'EOF'
      [colors-dark]
      background=000000
      foreground=c6c6c6
      EOF
      fi
    '';
  };
}
