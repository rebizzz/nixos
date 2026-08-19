{inputs, ...}: {
  flake.modules.nixos.desktop = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
        # Not a caelestia default (its "uwsm" dotfiles component is opt-in,
        # not enabled by default) and ly is reported to not always exit
        # cleanly before a UWSM-wrapped Hyprland session starts.
        withUWSM = false;
      };

      # ydotool daemon, needed for caelestia's clipboard-paste-latest keybind
      ydotool.enable = true;

      nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 4d --keep 3";
          dates = "daily";
        };
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
    # caelestia's execs.lua manually launches a geoclue demo agent from an
    # Arch FHS path that doesn't exist on NixOS -- the NixOS-native
    # equivalent is just enabling the geoclue2 service, which activates
    # over D-Bus without needing a manually-launched agent.
    services.geoclue2.enable = true;
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
