_: {
  flake.modules.homeManager.ghostty = {
    config,
    lib,
    ...
  }: let
    themeFile = "${config.xdg.configHome}/ghostty/themes/noctalia";
  in {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;

      settings = {
        theme = "noctalia";

        font-family = "JetBrainsMono Nerd Font Mono";
        font-size = 13;

        window-padding-x = 8;
        window-padding-y = 8;
        window-padding-balance = true;
        window-decoration = "none";
        window-inherit-working-directory = true;
        resize-overlay = "never";

        background-opacity = 0.85;
        background-blur = false;

        copy-on-select = true;

        cursor-style = "block";
        cursor-style-blink = false;
        mouse-hide-while-typing = true;

        term = "xterm-256color";

        confirm-close-surface = false;
        gtk-single-instance = true;
        app-notifications = "no-clipboard-copy";

        shell-integration = "fish";
        shell-integration-features = "cursor,sudo,title";
      };
    };

    # `theme = noctalia` fails ghostty's config validation until noctalia has
    # rendered the template once. Noctalia overwrites this on the next apply.
    home.activation.ghosttyNoctaliaTheme = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ ! -e "${themeFile}" ]; then
        run mkdir -p $VERBOSE_ARG "$(dirname "${themeFile}")"
        run tee "${themeFile}" >/dev/null <<'EOF'
      background = 000000
      foreground = c6c6c6
      cursor-color = c6c6c6
      EOF
      fi
    '';
  };
}
