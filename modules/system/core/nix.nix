{inputs, lib, ...}: {
  flake.modules.nixos.nix = _: {
    nixpkgs.config.allowUnfree = true;
    programs = {
      command-not-found.enable = false;
      nix-ld.enable = true;
    };

    documentation = {
      enable = false;
      doc.enable = false;
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
        auto-optimise-store = true;

        max-jobs = "auto";
        cores = 0;

        keep-outputs = false;
        keep-derivations = false;

        builders-use-substitutes = true;
        download-buffer-size = 268435456;
        connect-timeout = 5;

        substituters = lib.mkForce [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://niri-epireyn.cachix.org"
          "https://noctalia.cachix.org"
        ];

        trusted-users = ["root" "@wheel"];

        trusted-public-keys = lib.mkForce [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "niri-epireyn.cachix.org-1:tlVyFN7CtsDT+ZcLPS+ekFWeT1X6X4OqvWqbBMyIzFA="
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];

        fallback = true;
      };

      optimise.automatic = true;
    };
  };
}
