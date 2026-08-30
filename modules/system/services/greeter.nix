_: {
  flake.modules.nixos.greeter = {
    pkgs,
    config,
    lib,
    ...
  }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          # Use the wayland-sessions directory populated by programs.hyprland.enable.
          # This makes tuigreet show the session list and launch start-hyprland
          # via its own desktop entry (which has the correct PATH baked in).
          command = lib.concatStringsSep " " [
            "${lib.getExe pkgs.greetd.tuigreet}"
            "--time"
            "--time-format '%H:%M %a, %b %d'"
            "--remember"
            "--remember-session"
            "--asterisks"
            "--user-menu"
            "--sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions"
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
