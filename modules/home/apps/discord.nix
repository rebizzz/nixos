{inputs, ...}: {
  flake.modules.homeManager.discord = {...}: {
    imports = [inputs.nixcord.homeModules.nixcord];

    programs.nixcord = {
      enable = true;
      discord = {
        branch = "canary";
        equicord.enable = true;
      };

      config = {
        useQuickCss = true;
        themeLinks = [
          "https://raw.githubusercontent.com/LuckFire/amoled-cord/343808e7d5297223e43868b3955da4cbbd01ceef/clients/amoled-cord.theme.css"
        ];
      };
    };
  };
}
