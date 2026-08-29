_: {
  wayland.windowManager.hyprland.extraConfig = ''
    animations {
        enabled = true

        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        bezier = md3_standard, 0.2, 0.0, 0, 1.0
        bezier = md3_decel, 0.05, 0.7, 0.1, 1.0
        bezier = md3_accel, 0.3, 0.0, 0.8, 0.15
        bezier = overshot, 0.05, 0.9, 0.1, 1.05
        bezier = menu_decel, 0.1, 1.0, 0.0, 1.0
        bezier = menu_accel, 0.38, 0.04, 1.0, 0.07

        # Windows
        animation = windows, 1, 4, md3_decel, popin 80%
        animation = windowsIn, 1, 4, md3_decel, popin 80%
        animation = windowsOut, 1, 3, md3_accel, popin 80%
        animation = windowsMove, 1, 4, wind, slide

        # Layers (Noctalia bars, panels, notifications)
        animation = layers, 1, 4, menu_decel, slide
        animation = layersIn, 1, 4, menu_decel, slide
        animation = layersOut, 1, 3, menu_accel, slide
        animation = fadeLayersIn, 1, 4, menu_decel
        animation = fadeLayersOut, 1, 3, menu_accel

        # Fades
        animation = fade, 1, 4, md3_decel
        animation = fadeIn, 1, 4, md3_decel
        animation = fadeOut, 1, 3, md3_accel
        animation = fadeSwitch, 1, 4, md3_decel
        animation = fadeDim, 1, 4, md3_decel

        # Workspaces
        animation = workspaces, 1, 5, menu_decel, slide
        animation = specialWorkspace, 1, 5, md3_decel, slidefadevert 15%

        # Borders
        animation = border, 1, 6, md3_decel
        animation = borderangle, 1, 20, liner, loop
    }
  '';
}
