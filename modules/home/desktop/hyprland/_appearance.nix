_: {
  desktop.hyprland.extraConfig = ''
    # Decoration
    decoration {
        rounding = 12
        active_opacity = 1.0
        inactive_opacity = 1.0

        shadow {
            enabled = true
            range = 45
            render_power = 3
            color = rgba(00000088)
            offset = 0 10
        }

        blur {
            enabled = true
            size = 6
            passes = 3
            noise = 0.02
            brightness = 0.95
            contrast = 0.95
            vibrancy = 1.25
            popups = true
        }
    }

    # Window Group & Tabs
    group {
        col.border_active = rgba(7aa2f7ee)
        col.border_inactive = rgba(565f89aa)
        col.border_locked_active = rgba(f7768eee)
        col.border_locked_inactive = rgba(565f89aa)

        groupbar {
            enabled = true
            font_family = Inter
            font_size = 10
            gradients = true
            height = 14
            priority = 3
            render_titles = true
            scrolling = true
            text_color = rgba(ffffffff)
            col.active = rgba(7aa2f7ee)
            col.inactive = rgba(565f89aa)
            col.locked_active = rgba(f7768eee)
            col.locked_inactive = rgba(565f89aa)
        }
    }
  '';
}
