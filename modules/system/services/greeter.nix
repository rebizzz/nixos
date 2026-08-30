_: {
  flake.modules.nixos.greeter = {
    pkgs,
    lib,
    ...
  }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Use the full Nix store path to start-hyprland so the greeter user
          # doesn't need it in PATH. tuigreet --cmd forks exactly this binary.
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.tuigreet}"
            "--time"
            "--time-format '%H:%M %a, %b %d'"
            "--remember"
            "--remember-session"
            "--asterisks"
            "--user-menu"
            "--cmd ${pkgs.hyprland}/bin/start-hyprland"
          ];
          user = "greeter";
        };
      };
    };

    # Unlock GNOME Keyring automatically on graphical login
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
