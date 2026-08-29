_: {
  wayland.windowManager.hyprland.extraConfig = ''
    # Terminal
    windowrulev2 = opacity 0.95 0.95, class:^(kitty)$

    # Satty screenshot annotation tool
    windowrulev2 = float, class:^(com\.gabm\.satty|satty)$
    windowrulev2 = pin, class:^(com\.gabm\.satty|satty)$
    windowrulev2 = size 1344 756, class:^(com\.gabm\.satty|satty)$
    windowrulev2 = center, class:^(com\.gabm\.satty|satty)$

    # Editor
    windowrulev2 = opacity 0.97 0.97, class:^(code)$

    # Brave Browser
    windowrulev2 = opacity 1.0 1.0, class:^(brave-browser|Brave-browser|brave)$
    windowrulev2 = idleinhibit fullscreen, class:^(brave-browser|Brave-browser|brave)$

    # File pickers & dialogs
    windowrulev2 = float, title:^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)$
    windowrulev2 = center, title:^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)$

    # Policykit / auth / keyring
    windowrulev2 = float, class:^(lxqt-policykit.*|udiskie|org\.gnome\.seahorse\\.Application)$
    windowrulev2 = center, class:^(lxqt-policykit.*|udiskie|org\.gnome\.seahorse\\.Application)$

    # Discord
    windowrulev2 = opacity 0.90 0.90, class:^(discord|discord-canary|Discord|DiscordCanary|equibop|Equibop)$

    # Noctalia Settings
    windowrulev2 = float, class:^(dev\.noctalia\.Noctalia)$
    windowrulev2 = size 1020 900, class:^(dev\.noctalia\.Noctalia)$
    windowrulev2 = center, class:^(dev\.noctalia\.Noctalia)$

    # Noctalia / Screen Share Picker
    windowrulev2 = float, class:^(dev\.noctalia\.UmbrielSharePicker)$
    windowrulev2 = size 800 600, class:^(dev\.noctalia\.UmbrielSharePicker)$
    windowrulev2 = center, class:^(dev\.noctalia\.UmbrielSharePicker)$

    # Audio / Network / Bluetooth controls
    windowrulev2 = float, class:^(pavucontrol|org\.pulseaudio\.pavucontrol|nm-connection-editor|blueman-manager|org\.gnome\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)$
    windowrulev2 = center, class:^(pavucontrol|org\.pulseaudio\.pavucontrol|nm-connection-editor|blueman-manager|org\.gnome\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)$

    # Picture-in-Picture
    windowrulev2 = float, title:^(Picture-in-Picture)$
    windowrulev2 = pin, title:^(Picture-in-Picture)$
    windowrulev2 = size 640 360, title:^(Picture-in-Picture)$
    windowrulev2 = center, title:^(Picture-in-Picture)$

    # Desktop Portals
    windowrulev2 = float, class:^(xdg-desktop-portal(-.*)?|org\.freedesktop\.impl\.portal\\.desktop\\..*)$
    windowrulev2 = center, class:^(xdg-desktop-portal(-.*)?|org\\.freedesktop\.impl\\.portal\\.desktop\\..*)$

    # MPV
    windowrulev2 = opacity 1.0 1.0, class:^(mpv)$
    windowrulev2 = idleinhibit fullscreen, class:^(mpv)$

    # Steam
    windowrulev2 = float, class:^(steam)$, title:^(Steam)$
    windowrulev2 = size 1100 700, class:^(steam)$, title:^(Steam)$
    windowrulev2 = center, class:^(steam)$, title:^(Steam)$
    windowrulev2 = float, class:^(steam)$, title:^(Friends List)$
    windowrulev2 = size 460 800, class:^(steam)$, title:^(Friends List)$
    windowrulev2 = center, class:^(steam)$, title:^(Friends List)$
    windowrulev2 = fullscreen, class:^(steam_app_[0-9]+)$

    # Screen share picker
    windowrulev2 = float, title:^(Select what to share)$
    windowrulev2 = center, title:^(Select what to share)$

    # Cheatsheet popup
    windowrulev2 = float, class:^(hyprland-cheatsheet)$
    windowrulev2 = size 920 680, class:^(hyprland-cheatsheet)$
    windowrulev2 = center, class:^(hyprland-cheatsheet)$

    # Layer rules
    layerrule = blur, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)
    layerrule = ignorealpha 0.5, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)
    layerrule = blurpopups, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)
  '';
}
