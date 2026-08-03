_: {
  flake.modules.homeManager.foot = {lib, ...}: {
    programs.foot = {
      enable = true;
      settings = {
        main = {
          include = "~/.config/foot/themes/noctalia";
          term = "xterm-256color";
          font = "JetBrainsMono Nerd Font Mono:size=13";
          pad = "8x8";
          selection-target = "clipboard";
        };
        colors-dark = {
          alpha = "0.85";
        };
        scrollback = {
          lines = 2000;
        };
        url = {
          launch = "brave-origin";
          label-letters = "sadfjklewcmpgh";
        };
      };
    };

    home.activation.removeFootIni = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ -f "$HOME/.config/foot/foot.ini" ] && [ ! -L "$HOME/.config/foot/foot.ini" ]; then
        rm -f "$HOME/.config/foot/foot.ini"
      fi
      if [ -f "$HOME/.config/foot/foot.ini.bak" ]; then
        rm -f "$HOME/.config/foot/foot.ini.bak"
      fi
    '';
  };
}
