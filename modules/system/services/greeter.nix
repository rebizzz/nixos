_: {
  flake.modules.nixos.greeter = _: {
    services.displayManager = {
      ly.enable = true;
      defaultSession = "hyprland";
    };

    # Unlock GNOME Keyring automatically on graphical login
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.ly.enableGnomeKeyring = true;
  };
}
