_: {
  flake.modules.nixos.ly-greeter = {...}: {
    services.displayManager.ly = {
      enable = true;
      settings = {
        animation = "matrix";
      };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.ly.enableGnomeKeyring = true;
  };
}
