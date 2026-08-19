_: {
  flake.modules.homeManager.fish = _: {
    home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

    programs = {
      ripgrep.enable = true;

      eza = {
        enable = true;
        enableFishIntegration = true;
      };

      bat.enable = true;

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        options = ["--cmd cd"];
      };

      fish = {
        enable = true;
        shellAbbrs = {
          ls = "eza";
          cat = "bat";
          grep = "rg";
        };
        interactiveShellInit = ''
          set -g fish_greeting ""
        '';
      };
    };
  };
}
