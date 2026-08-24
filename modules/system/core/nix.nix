{inputs, ...}: {
  flake.modules.nixos.nix = _: {
    nixpkgs.config.allowUnfree = true;
    environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
    programs = {
      command-not-found.enable = false;
      nix-ld.enable = true;
    };

    documentation = {
      enable = false;
      nixos.enable = false;
      man.enable = false;
      info.enable = false;
    };
    environment.defaultPackages = [];

    nix = {
      channel.enable = false;
      registry.nixpkgs.flake = inputs.nixpkgs;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      settings = {
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = true;

        max-jobs = "auto";
        cores = 0;

        keep-outputs = false;
        keep-derivations = false;

        builders-use-substitutes = true;
        download-buffer-size = 268435456;
        connect-timeout = 5;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://noctalia.cachix.org"
          "https://niri-epireyn.cachix.org"
          "https://niri.cachix.org"
        ];

        trusted-users = ["root" "@wheel"];

        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
          "niri.cachix.org-1:Wv0mDh9FQ5eaSobfq25S971P7h17F53X7L4qfK07e0c="
        ];

        fallback = true;

        min-free = 1073741824;
        max-free = 3221225472;
      };

      optimise = {
        automatic = true;
        dates = ["daily"];
      };

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 2d";
      };

      daemonCPUSchedPolicy = "batch";
      daemonIOSchedClass = "best-effort";
      daemonIOSchedPriority = 7;
    };
  };
}
