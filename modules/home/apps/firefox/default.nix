# credits: https://github.com/arkenfox/user.js https://github.com/yokoffing/Betterfox
{...}: {
  flake.modules.homeManager.firefox = {pkgs, ...}: {
    imports = [
      ./_arkenfox.nix
      ./_betterfox.nix
      ./_customization.nix
      ./_extensions.nix
      ./_policies.nix
    ];
    programs.firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles.rebiz = {
        id = 0;
        isDefault = true;
      };
    };
  };
}
