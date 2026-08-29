{inputs, ...}: {
  flake.modules.nixos.desktop = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      hyprland = {
        enable = true;
      };

      nh = {
        enable = true;
        flake = "${config.users.users.${config.myConfig.user.name}.home}/opt/nixos-config";
      };

      dconf.enable = true;
      xfconf.enable = true;

      thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
          thunar-media-tags-plugin
          thunar-shares-plugin
        ];
      };

      appimage = {
        enable = true;
        binfmt = true;
      };
    };

    services = {
      flatpak.enable = true;
      tumbler.enable = true;
    };

    environment.systemPackages = [
      pkgs.ffmpegthumbnailer
      pkgs.file-roller
      pkgs.gnome-disk-utility

      pkgs.loupe
      pkgs.papers
      pkgs.xdg-utils
      pkgs.dex
      pkgs.wl-clipboard
      pkgs.satty
      pkgs.libnotify
      pkgs.pear-desktop
      inputs.hyprland-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
      pkgs.hyprpicker
      pkgs.hyprcursor
    ];
  };
}
