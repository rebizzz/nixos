_: {
  desktop.hyprland.extraConfig = ''
    # Window Rules (Hyprland 0.56 standard syntax)
    windowrule = opacity 0.95 0.95, match:class kitty
    windowrule = float 1, match:class (com\.gabm\.satty|satty)
    windowrule = pin 1, match:class (com\.gabm\.satty|satty)
    windowrule = size 1344 756, match:class (com\.gabm\.satty|satty)
    windowrule = center 1, match:class (com\.gabm\.satty|satty)
    windowrule = opacity 0.97 0.97, match:class code
    windowrule = opacity 1.0 1.0, match:class (brave-browser|Brave-browser|brave)
    windowrule = float 1, match:title (Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)
    windowrule = center 1, match:title (Open File|Select|Choose a wallpaper|Open Folder|Save As|Library|Choose Where to Download|File Operation Progress|Rename|Copy Files|Move Files|Search Files)
    windowrule = float 1, match:class (lxqt-policykit.*|udiskie|org\.gnome\.seahorse\.Application)
    windowrule = center 1, match:class (lxqt-policykit.*|udiskie|org\.gnome\.seahorse\.Application)
    windowrule = opacity 0.90 0.90, match:class (discord|discord-canary|Discord|DiscordCanary|equibop|Equibop)
    windowrule = float 1, match:class dev\.noctalia\.Noctalia
    windowrule = size 1020 900, match:class dev\.noctalia\.Noctalia
    windowrule = center 1, match:class dev\.noctalia\.Noctalia
    windowrule = float 1, match:class dev\.noctalia\.UmbrielSharePicker
    windowrule = size 800 600, match:class dev\.noctalia\.UmbrielSharePicker
    windowrule = center 1, match:class dev\.noctalia\.UmbrielSharePicker
    windowrule = float 1, match:class (pavucontrol|org\.pulseaudio\.pavucontrol|nm-connection-editor|blueman-manager|org\.gnome\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)
    windowrule = center 1, match:class (pavucontrol|org\.pulseaudio\.pavucontrol|nm-connection-editor|blueman-manager|org\.gnome\.Nm-connection-editor|Emulator|zenity|qalculate-gtk)
    windowrule = float 1, match:title Picture-in-Picture
    windowrule = pin 1, match:title Picture-in-Picture
    windowrule = size 640 360, match:title Picture-in-Picture
    windowrule = center 1, match:title Picture-in-Picture
    windowrule = float 1, match:class (xdg-desktop-portal(-.*)?|org\.freedesktop\.impl\.portal\.desktop\..*)
    windowrule = center 1, match:class (xdg-desktop-portal(-.*)?|org\.freedesktop\.impl\.portal\.desktop\..*)
    windowrule = opacity 1.0 1.0, match:class mpv
    windowrule = float 1, match:class steam, match:title Steam
    windowrule = size 1100 700, match:class steam, match:title Steam
    windowrule = center 1, match:class steam, match:title Steam
    windowrule = float 1, match:class steam, match:title Friends List
    windowrule = size 460 800, match:class steam, match:title Friends List
    windowrule = center 1, match:class steam, match:title Friends List
    windowrule = fullscreen 1, match:class steam_app_[0-9]+
    windowrule = float 1, match:title Select what to share
    windowrule = center 1, match:title Select what to share
    windowrule = float 1, match:class hyprland-cheatsheet
    windowrule = size 920 680, match:class hyprland-cheatsheet
    windowrule = center 1, match:class hyprland-cheatsheet

    # Layer Rules
    layerrule = blur 1, match:namespace noctalia.*
    layerrule = ignore_alpha 0.5, match:namespace noctalia.*
    layerrule = blur_popups 1, match:namespace noctalia.*
  '';
}
