_: {
  wayland.windowManager.hyprland.settings = {
    animations = {
      enabled = true;

      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
        "md3_standard, 0.2, 0.0, 0, 1.0"
        "md3_decel, 0.05, 0.7, 0.1, 1.0"
        "md3_accel, 0.3, 0.0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.05"
        "menu_decel, 0.1, 1.0, 0.0, 1.0"
        "menu_accel, 0.38, 0.04, 1.0, 0.07"
      ];

      animation = [
        # Windows
        "windows, 1, 4, md3_decel, popin 80%"
        "windowsIn, 1, 4, md3_decel, popin 80%"
        "windowsOut, 1, 3, md3_accel, popin 80%"
        "windowsMove, 1, 4, wind, slide"

        # Layers (Noctalia bars, panels, notifications)
        "layers, 1, 4, menu_decel, slide"
        "layersIn, 1, 4, menu_decel, slide"
        "layersOut, 1, 3, menu_accel, slide"
        "fadeLayersIn, 1, 4, menu_decel"
        "fadeLayersOut, 1, 3, menu_accel"

        # Fades
        "fade, 1, 4, md3_decel"
        "fadeIn, 1, 4, md3_decel"
        "fadeOut, 1, 3, md3_accel"
        "fadeSwitch, 1, 4, md3_decel"
        "fadeDim, 1, 4, md3_decel"

        # Workspaces
        "workspaces, 1, 5, menu_decel, slide"
        "specialWorkspace, 1, 5, md3_decel, slidefadevert 15%"

        # Borders
        "border, 1, 6, md3_decel"
        "borderangle, 1, 20, liner, loop"
      ];
    };
  };
}
