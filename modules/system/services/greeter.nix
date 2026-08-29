_: {
  flake.modules.nixos.greeter = {
    pkgs,
    ...
  }: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --time-format '%H:%M %a, %b %d' --remember --remember-session --asterisks --user-menu --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    # Unlock GNOME Keyring automatically on graphical login
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
