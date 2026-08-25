_: {
  wayland.windowManager.hyprland.settings.config = {
    # cycled via Super+Tab, see _binds.nix
    general.layout = "scrolling";

    dwindle.preserve_split = true;

    scrolling = {
      fullscreen_on_one_column = true;
      column_width = 0.5;
      follow_focus = true;
      direction = "right";
    };
  };

  wayland.windowManager.hyprland.settings.workspace_rule = [
    {
      workspace = "special:scratch";
      gaps_in = 16;
      gaps_out = 32;
    }
  ];
}
