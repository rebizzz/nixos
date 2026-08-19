{inputs, ...}: {
  imports = [inputs.flake-parts.flakeModules.modules];

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks (inputs.self.deploy or {});

    devShells.default = pkgs.mkShell {
      packages = [
        inputs.deploy-rs.packages.${system}.default
        pkgs.sops
        pkgs.age
        pkgs.nixos-anywhere
      ];
    };
  };
}
