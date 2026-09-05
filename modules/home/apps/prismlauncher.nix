_: {
  flake.modules.homeManager.prismlauncher = {pkgs, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        gamemodeSupport = true;
        controllerSupport = true;
        additionalPrograms = [pkgs.gamemode];
        jdks = [pkgs.jdk21];
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
