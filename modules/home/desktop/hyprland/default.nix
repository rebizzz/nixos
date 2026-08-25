_: {
  flake.modules.homeManager.hyprland = {
    imports = [
      ./_look.nix
      ./_animations.nix
      ./_input.nix
      ./_layout.nix
      ./_rules.nix
      ./_binds.nix
      ./_submaps.nix
      ./_exec.nix
      ./_extra.nix
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      systemd.variables = ["--all"];
    };
  };
}
