_: {
  programs.umbriel.settings = {
    general = {
      autostart = ["dex --autostart --environment umbriel"];
      mod_key = "Super";
      show_cheatsheet = false;
      focus_on_activate = true;
      xwayland = true;
      honor_restored_maximize = true;
    };

    workspaces.back_and_forth = true;

    overview.zoom = 0.55;

    hot_corners.top_left = {
      enabled = true;
      delay_ms = 500;
      action = "overview-open";
    };

    # live colour-scheme handoff, mirrors the old require("noctalia").apply_theme() setup
    include.files = ["noctalia.toml"];
  };
}
