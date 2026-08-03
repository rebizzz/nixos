{inputs, ...}: {
  flake.modules.nixos.noctalia-greeter = {pkgs, ...}: {
    imports = [inputs.noctalia-greeter.nixosModules.default];

    programs.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "niri";
        user.default = "rebiz";
        keyboard.layout = "us";
        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
      };
    };

    services.gnome.gnome-keyring.enable = true;
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
