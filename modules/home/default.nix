{inputs, ...}: let
  homeDir = "/home/rebiz";
  bookmarks = ''
    file://${homeDir}/Documents Documents
    file://${homeDir}/Downloads Downloads
    file://${homeDir}/Music Music
    file://${homeDir}/Pictures Pictures
    file://${homeDir}/Videos Videos
  '';
in {
  flake.modules.homeManager.default = {pkgs, ...}: {
    imports = with inputs.self.modules.homeManager; [
      inputs.nix-index-database.homeModules.nix-index
      niri
      noctalia
      foot
      fish
      git
      lazyvim
      brave
      udiskie
      sounds
      vesktop
      theme
      mime
    ];

    home = {
      username = "rebiz";
      homeDirectory = homeDir;
      stateVersion = "26.11";
      packages = [pkgs.gpu-screen-recorder];
      file = {
        ".face".source = ../../assets/avatar.jpeg;
        ".face.icon".source = ../../assets/avatar.jpeg;
        ".config/gtk-3.0/bookmarks".text = bookmarks;
      };
      sessionVariables = {
        BROWSER = "brave-origin";
      };
    };

    programs.nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    programs.nix-index-database.comma.enable = true;
  };
}
