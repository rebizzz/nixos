{
  flake.modules.nixos.desktop = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      niri.package = pkgs.niri-stable;

      nh = {
        enable = true;
        flake = "${config.users.users.rebiz.home}/opt/nixos-config";
      };

      dconf.enable = true;

      appimage = {
        enable = true;
        binfmt = true;
      };
    };

    services.flatpak.enable = true;

    environment.systemPackages = [
      pkgs.nautilus
      pkgs.ffmpegthumbnailer
      pkgs.file-roller
      pkgs.gnome-disk-utility

      pkgs.loupe

      pkgs.evince
      pkgs.gnome-calculator
      pkgs.xdg-utils
      pkgs.dex
      pkgs.wl-clipboard
      pkgs.satty
      pkgs.libnotify
      pkgs.pear-desktop
    ];
  };
}
