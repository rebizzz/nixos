_: {
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        inter
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        liberation_ttf
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
      ];
      fontconfig = {
        defaultFonts = {
          serif = ["Noto Serif"];
          sansSerif = ["Inter" "Noto Sans"];
          monospace = ["FiraCode Nerd Font" "JetBrainsMono Nerd Font Mono"];
          emoji = ["Noto Color Emoji"];
        };
        subpixel.lcdfilter = "default";
      };
    };
  };
}
