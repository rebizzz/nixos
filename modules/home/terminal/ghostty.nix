_: {
  flake.modules.homeManager.ghostty = {...}: {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;
      installBatSyntax = true;

      settings = {
        theme = "catppuccin-mocha";

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
  };
}
