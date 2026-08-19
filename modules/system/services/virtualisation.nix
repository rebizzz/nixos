{inputs, ...}: {
  flake.modules.nixos.virtualisation = {
    imports = [inputs.self.modules.nixos.podman-base];
  };
}
