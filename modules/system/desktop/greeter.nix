{inputs, ...}: {
  flake.modules.nixos.greeter = {
    pkgs,
    config,
    ...
  }: {
    imports = [inputs.noctalia-greeter.nixosModules.default];

    services.displayManager.noctalia-greeter = {
      enable = true;
      settings = {
        session.default = "umbriel";
        user.default = config.myConfig.user.name;
        keyboard.layout = "us";
        cursor = {
          theme = "Bibata-Modern-Classic";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
      };
    };

    services.greetd = {
      restart = false;
      settings.initial_session = {
        command = "${inputs.umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/start-umbriel";
        user = config.myConfig.user.name;
      };
    };
  };
}
