{inputs, ...}: {
  flake.colmena.meta = {
    nixpkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    specialArgs = {inherit inputs;};
  };

  flake.colmenaHive = inputs.colmena.lib.makeHive inputs.self.colmena;
}
