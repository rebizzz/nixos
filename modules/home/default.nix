{inputs, ...}: {
  flake.modules.homeManager.default = {
    pkgs,
    config,
    osConfig,
    ...
  }: let
    homeDir = config.home.homeDirectory;
    bookmarks = ''
      file://${homeDir}/Documents Documents
      file://${homeDir}/Downloads Downloads
      file://${homeDir}/Music Music
      file://${homeDir}/Pictures Pictures
      file://${homeDir}/Videos Videos
    '';
  in {
    imports = with inputs.self.modules.homeManager; [
      inputs.nix-index-database.homeModules.nix-index
      hyprland
      noctalia
      kitty
      fish
      git
      nano
      brave
      sounds
      discord
      theme
      mime
    ];

    home = {
      username = osConfig.myConfig.user.name;
      homeDirectory = osConfig.myConfig.user.home;
      stateVersion = "26.11";
      packages = [
        pkgs.gpu-screen-recorder
        pkgs.udiskie
        pkgs.pavucontrol
      ];
      file = {
        ".face".source = ../../assets/avatar.jpeg;
        ".face.icon".source = ../../assets/avatar.jpeg;
        ".config/gtk-3.0/bookmarks".text = bookmarks;
      };
      sessionVariables = {
        BROWSER = "brave-origin";
      };
    };

    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = false;
    };
    news.display = "show";

    programs = {
      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };
      nix-index-database = {
        comma = {
          enable = true;
        };
      };
    };
  };
}
