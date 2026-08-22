{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [inputs.flake-parts.flakeModules.modules];

  perSystem = {
    pkgs,
    system,
    ...
  }: let
    # Use the nixpkgs binary cache for deploy-rs instead of building it from
    # the flake: keep the flake's lib (activate.nixos etc.), but take the CLI
    # derivation from nixpkgs.
    deployPkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [
        inputs.deploy-rs.overlays.default
        (self: super: {
          deploy-rs = {
            inherit (pkgs) deploy-rs;
            lib = super.deploy-rs.lib;
          };
        })
      ];
    };
  in {
    devShells.default = pkgs.mkShell {
      packages = [
        deployPkgs.deploy-rs.deploy-rs
        pkgs.sops
        pkgs.age
        pkgs.nixos-anywhere
        pkgs.just
      ];
    };
  };
}
