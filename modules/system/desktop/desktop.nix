{inputs, ...}: {
  flake.modules.nixos.desktop = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      niri.package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-stable;

      nh = {
        enable = true;
        flake = "${config.users.users.${config.myConfig.user.name}.home}/opt/nixos-config";
      };

      dconf.enable = true;

      appimage = {
        enable = true;
        binfmt = true;
      };
    };

    services.flatpak.enable = true;
    services.tailscale.enable = true;
    environment.systemPackages = [
      pkgs.nautilus
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
