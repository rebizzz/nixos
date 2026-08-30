_: {
  desktop.hyprland.settings = {
    # Window Rules – Hyprland 0.56 syntax (match: prefix)
    windowrule = [
      "opacity 0.95 0.95, match:class kitty"
      "float 1, match:class (com\\.gabm\\.satty|satty)"
      "pin 1, match:class (com\\.gabm\\.satty|satty)"
      "size 1344 756, match:class (com\\.gabm\\.satty|satty)"
      "center 1, match:class (com\\.gabm\\.satty|satty)"
      "opacity 0.97 0.97, match:class code"
      "opacity 1.0 1.0, match:class (brave-browser|Brave-browser|brave)"
      # File dialogs
      "float 1, match:title (Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)"
      "center 1, match:title (Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)"
      # Polkit / system dialogs
      "float 1, match:class (lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)"
      "center 1, match:class (lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)"
      # Discord
      "opacity 0.90 0.90, match:class (discord|discord-canary|Discord|DiscordCanary|equibop|Equibop)"
      # Noctalia windows
      "float 1, match:class dev\\.noctalia\\.Noctalia"
      "size 1020 900, match:class dev\\.noctalia\\.Noctalia"
      "center 1, match:class dev\\.noctalia\\.Noctalia"
      "float 1, match:class dev\\.noctalia\\.UmbrielSharePicker"
      "size 800 600, match:class dev\\.noctalia\\.UmbrielSharePicker"
      "center 1, match:class dev\\.noctalia\\.UmbrielSharePicker"
      # Audio / system utilities
      "float 1, match:class (pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)"
      "center 1, match:class (pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)"
      # Picture-in-Picture
      "float 1, match:title Picture-in-Picture"
      "pin 1, match:title Picture-in-Picture"
      "size 640 360, match:title Picture-in-Picture"
      "center 1, match:title Picture-in-Picture"
      # XDG portals
      "float 1, match:class (xdg-desktop-portal(-.*)?|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)"
      "center 1, match:class (xdg-desktop-portal(-.*)?|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)"
      # Media
      "opacity 1.0 1.0, match:class mpv"
      # Steam
      "float 1, match:class steam, match:title Steam"
      "size 1100 700, match:class steam, match:title Steam"
      "center 1, match:class steam, match:title Steam"
      "float 1, match:class steam, match:title Friends List"
      "size 460 800, match:class steam, match:title Friends List"
      "center 1, match:class steam, match:title Friends List"
      "fullscreen 1, match:class steam_app_[0-9]+"
      # Screen share picker (Noctalia / Umbriel)
      "float 1, match:title Select what to share"
      "center 1, match:title Select what to share"
      # Hyprland cheatsheet terminal
      "float 1, match:class hyprland-cheatsheet"
      "size 920 680, match:class hyprland-cheatsheet"
      "center 1, match:class hyprland-cheatsheet"
    ];

    # Layer Rules – Noctalia blurs
    layerrule = [
      "blur 1, match:namespace noctalia.*"
      "ignore_alpha 0.5, match:namespace noctalia.*"
      "blur_popups 1, match:namespace noctalia.*"
    ];
  };
}
