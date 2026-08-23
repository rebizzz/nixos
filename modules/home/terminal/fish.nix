_: {
  flake.modules.homeManager.fish = _: {
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
        options = ["--cmd" "cd"];
      };

      fish = {
        enable = true;
        shellAbbrs = {
          ls = "eza";
          cat = "bat --paging=never";
        };
        interactiveShellInit = ''
          set -g fish_greeting ""
        '';
      };
    };
  };
}
