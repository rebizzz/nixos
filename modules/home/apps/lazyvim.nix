{inputs, ...}: {
  flake.modules.homeManager.lazyvim = _: {
    imports = [inputs.lazyvim.homeManagerModules.default];

    programs.lazyvim = {
      enable = true;
    };

    programs.neovim.defaultEditor = true;

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
