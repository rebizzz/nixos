{inputs, ...}: {
  flake.modules.homeManager.umbriel = {
    imports = [
      inputs.umbriel.homeModules.default
      ./_general.nix
      ./_appearance.nix
      ./_animation.nix
      ./_input.nix
      ./_layout.nix
      ./_output.nix
      ./_rules.nix
      ./_binds.nix
    ];

    programs.umbriel = {
      enable = true;
      validateConfig = false;
    };
  };
}
