{
  description = "Minimal flake for iterating on laptop's disk layout and hardware config before deploying the main flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preservation.url = "github:nix-community/preservation";
  };

  outputs = {
    nixpkgs,
    disko,
    preservation,
    ...
  }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        preservation.nixosModules.default
        ../modules/hosts/laptop/_disko.nix
        ../modules/hosts/laptop/_hardware.nix
        ./configuration.nix
      ];
    };
  };
}
