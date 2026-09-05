_: {
  flake.modules.homeManager.prismlauncher = {pkgs, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        gamemodeSupport = true;
        controllerSupport = true;
        additionalPrograms = [pkgs.gamemode];
      };
      settings = {
        ApplicationTheme = "dark";
        CloseAfterLaunch = true;
        ShowConsoleOnError = true;
        EnableFeralGamemode = true;
      };
    };
  };
}
