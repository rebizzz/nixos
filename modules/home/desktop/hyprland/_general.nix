_: {
  desktop.hyprland.settings = {
    "exec-once" = [
      "dex --autostart --environment hyprland"
      # Propagate compositor env into systemd user session so that
      # noctalia.service (WantedBy=graphical-session.target) starts correctly
      "dbus-update-activation-environment --systemd --all"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE DISPLAY"
      "systemctl --user start graphical-session.target"
    ];

    env = [
      "PROTON_ENABLE_WAYLAND,1"
      "DXVK_HDR,1"
      "GTK_THEME,Adwaita:dark"
      "QT_QPA_PLATFORMTHEME,qt5ct"
      "NIXOS_OZONE_WL,1"
      "ELECTRON_OZONE_PLATFORM_HINT,auto"
      "MOZ_ENABLE_WAYLAND,1"
      "SDL_VIDEODRIVER,wayland"
      "_JAVA_AWT_WM_NONREPARENTING,1"
      "CLUTTER_BACKEND,wayland"
      "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
    ];

    general = {
      gaps_in = 4;
      gaps_out = 8;
      border_size = 2;
      "col.active_border" = "rgba(7aa2f7ee)";
      "col.inactive_border" = "rgba(565f89aa)";
      layout = "scrolling";
      allow_tearing = false;
    };
  };
}
