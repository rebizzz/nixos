_: {
  desktop.hyprland.extraConfig = ''
    $mainMod = SUPER

    # Autostart
    exec-once = dex --autostart --environment hyprland
    exec-once = dbus-update-activation-environment --systemd --all

    # Environment Variables
    env = PROTON_ENABLE_WAYLAND,1
    env = DXVK_HDR,1
    env = GTK_THEME,Adwaita:dark
    env = QT_QPA_PLATFORMTHEME,qt5ct
    env = NIXOS_OZONE_WL,1
    env = ELECTRON_OZONE_PLATFORM_HINT,auto
    env = MOZ_ENABLE_WAYLAND,1
    env = SDL_VIDEODRIVER,wayland
    env = _JAVA_AWT_WM_NONREPARENTING,1
    env = CLUTTER_BACKEND,wayland
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1

    # General
    general {
        gaps_in = 4
        gaps_out = 8
        border_size = 2
        col.active_border = rgba(7aa2f7ee)
        col.inactive_border = rgba(565f89aa)
        layout = scrolling
        allow_tearing = false
    }
  '';
}
