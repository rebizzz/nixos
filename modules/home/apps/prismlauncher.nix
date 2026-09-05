_: {
  flake.modules.homeManager.prismlauncher = {pkgs, ...}: {
    programs.prismlauncher = {
      enable = true;
      package = pkgs.prismlauncher.override {
        gamemodeSupport = true;
        controllerSupport = true;
        jdks = [pkgs.temurin-bin-25];
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
