{
  description = "NixOS - Niri + Noctalia (dendritic)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    colmena.url = "github:nix-community/colmena";

    nixarr = {
      url = "github:nix-media-server/nixarr";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:4evy/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri.url = "github:epireyn/niri-flake";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    import-tree.url = "github:vic/import-tree";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;}
    {
      imports = [(inputs.import-tree ./modules)];

      flake.nixosModules.default = {imports = builtins.attrValues inputs.self.modules.nixos;};
      flake.homeManagerModules.default = {imports = builtins.attrValues inputs.self.modules.homeManager;};
    };
}
