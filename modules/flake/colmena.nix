{inputs, ...}: {
  flake.colmenaHive = inputs.colmena.lib.makeHive inputs.self.colmena;
}
