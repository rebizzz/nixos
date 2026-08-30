{inputs, ...}: {
  flake.modules.nixos.desktop = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.umbriel.nixosModules.default];

    programs = {
      umbriel = {
        enable = true;
        portalPackage = inputs.xdg-desktop-portal-umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };

      nh = {
        enable = true;
        flake = "${config.users.users.${config.myConfig.user.name}.home}/opt/nixos-config";
      };

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
    ];
  };
}
