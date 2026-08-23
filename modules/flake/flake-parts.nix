{inputs, ...}: {
  systems = ["x86_64-linux"];

  imports = [inputs.flake-parts.flakeModules.modules];

  perSystem = {pkgs, ...}: {
    devShells.default = pkgs.mkShell {
      packages = [
        pkgs.deploy-rs
        pkgs.sops
        pkgs.age
        pkgs.nixos-anywhere
        pkgs.just
      ];
    };
  };
}
