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

    scratchpad = [
      {name = "special";}
      {
        name = "communication";
        spawn_when_empty = "equibop";
      }
      {name = "music";}
      {name = "sysmon";}
      {name = "todo";}
    ];

    overview = {
      zoom = 0.55;
      shortcuts = true;
      shortcut_keys = "1234567890";
    };

    environment = {
      QT_QPA_PLATFORM = "wayland;xcb";
      GDK_BACKEND = "wayland,x11";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      SDL_VIDEODRIVER = "wayland,x11";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    };

    hot_corners.top_left = {
      enabled = true;
      delay_ms = 500;
      action = "overview-open";
    };

    include.optional.files = ["noctalia.toml"];
  };
}
