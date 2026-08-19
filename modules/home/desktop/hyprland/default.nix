_: {
  flake.modules.homeManager.hyprland = {pkgs, ...}: {
    imports = [
      ./_settings.nix
      ./_rules.nix
      ./_binds.nix
      ./_extra.nix
      ./_exec.nix
      ./_scheme.nix
    ];

    home.packages = with pkgs; [
      hyprpicker
      cliphist
      trash-cli
      gammastep
      grim
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
    };
  };
}
