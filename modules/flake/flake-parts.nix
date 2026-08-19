{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [inputs.flake-parts.flakeModules.modules];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    devShells.default = pkgs.mkShell {
      packages = [
        inputs.colmena.packages.${system}.colmena
        pkgs.sops
        pkgs.age
        pkgs.nixos-anywhere
        pkgs.just
      ];
    };
  };
}
