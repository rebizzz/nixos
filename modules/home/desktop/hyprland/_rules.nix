_: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # Terminal
      "opacity 0.95 0.95, class:^(kitty)$"

      # Satty screenshot annotation tool
      "float, class:^(com\\.gabm\\.satty|satty)$"
      "pin, class:^(com\\.gabm\\.satty|satty)$"
      "size 1344 756, class:^(com\\.gabm\\.satty|satty)$"
      "center, class:^(com\\.gabm\\.satty|satty)$"

      # Editor
      "opacity 0.97 0.97, class:^(code)$"

      # File pickers & dialogs
      "float, title:^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)$"
      "center, title:^(Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)$"

      # Policykit / auth / keyring
      "float, class:^(lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)$"
      "center, class:^(lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)$"

      # Discord
      "opacity 0.90 0.90, class:^(discord|discord-canary|Discord|DiscordCanary|equibop|Equibop)$"

      # Noctalia Settings
      "float, class:^(dev\\.noctalia\\.Noctalia)$"
      "size 1020 900, class:^(dev\\.noctalia\\.Noctalia)$"
      "center, class:^(dev\\.noctalia\\.Noctalia)$"

      # Noctalia / Screen Share Picker
      "float, class:^(dev\\.noctalia\\.UmbrielSharePicker)$"
      "size 800 600, class:^(dev\\.noctalia\\.UmbrielSharePicker)$"
      "center, class:^(dev\\.noctalia\\.UmbrielSharePicker)$"

      # Audio / Network / Bluetooth controls
      "float, class:^(pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)$"
      "center, class:^(pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)$"

      # Picture-in-Picture
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "center, title:^(Picture-in-Picture)$"

      # Desktop Portals
      "float, class:^(xdg-desktop-portal(-.*)?|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)$"
      "center, class:^(xdg-desktop-portal(-.*)?|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)$"

      # MPV
      "opacity 1.0 1.0, class:^(mpv)$"

      # Steam
      "float, class:^(steam)$, title:^(Steam)$"
      "size 1100 700, class:^(steam)$, title:^(Steam)$"
      "center, class:^(steam)$, title:^(Steam)$"
      "float, class:^(steam)$, title:^(Friends List)$"
      "size 460 800, class:^(steam)$, title:^(Friends List)$"
      "center, class:^(steam)$, title:^(Friends List)$"
      "fullscreen, class:^(steam_app_[0-9]+)$"

      # Screen share picker
      "float, title:^(Select what to share)$"
      "center, title:^(Select what to share)$"

      # Cheatsheet popup
      "float, class:^(hyprland-cheatsheet)$"
      "size 920 680, class:^(hyprland-cheatsheet)$"
      "center, class:^(hyprland-cheatsheet)$"
    ];

    layerrule = [
      "blur, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)"
      "ignorealpha 0.5, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)"
      "blurpopups, noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)"
    ];
  };
}
