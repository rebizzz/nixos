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

    overview = {
      zoom = 0.55;
      shortcuts = true;
      shortcut_keys = "1234567890";
    };

    environment = {
      PROTON_ENABLE_WAYLAND = "1";
      DXVK_HDR = "1";
      GTK_THEME = "Adwaita:dark";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      CLUTTER_BACKEND = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    hot_corners.top_left = {
      enabled = true;
      delay_ms = 500;
      action = "overview-open";
    };

    # live colour-scheme handoff, mirrors the old require("noctalia").apply_theme() setup
    include.files = ["noctalia.toml"];
  };
}
