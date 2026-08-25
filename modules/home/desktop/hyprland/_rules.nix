_: {
  wayland.windowManager.hyprland.settings = {
    layer_rule = [
      {
        name = "noctalia-blur";
        match.namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";
        blur = true;
      }
      {
        name = "noctalia-backdrop-blur";
        match.namespace = "^noctalia-backdrop";
        blur = true;
      }
    ];

    window_rule = [
      {
        name = "kitty-blur";
        match.class = "^kitty$";
        opacity = "0.95 0.85";
      }
      {
        name = "satty-float";
        match.class = "^(com\\.gabm\\.satty|satty)$";
        float = true;
        no_anim = true;
        no_blur = true;
        no_shadow = true;
      }
      {
        name = "auth-dialogs-float";
        match.class = "^(lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)$";
        float = true;
      }
      {
        name = "vesktop-maximize";
        match = {
          class = "^(vesktop|Vesktop)$";
          title = "^(?!Vesktop Updater$).*$";
        };
        maximize = true;
      }
      {
        name = "vesktop-updater-float";
        match.title = "^Vesktop Updater$";
        float = true;
        center = true;
      }
      {
        name = "brave-maximize";
        match.class = "^(brave-browser|brave)$";
        maximize = true;
      }
      {
        name = "noctalia-settings-float";
        match.class = "^dev\\.noctalia\\.Noctalia$";
        float = true;
        size = [1020 900];
      }
      {
        name = "noctalia-share-picker-float";
        match.class = "^dev\\.noctalia\\.UmbrielSharePicker$";
        float = true;
        size = [800 600];
      }
      {
        name = "audio-net-floats";
        match.class = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor)$";
        float = true;
      }
      {
        name = "pip-float";
        match = {
          class = "^(brave|chromium).*";
          title = "^Picture-in-Picture$";
        };
        float = true;
        pin = true;
      }
      {
        name = "xdg-portal-float";
        match.class = "^xdg-desktop-portal-gtk$";
        float = true;
      }
      {
        name = "mpv-opaque";
        match.class = "^mpv$";
        opacity = "1.0 override 1.0 override";
      }
      {
        name = "steam-float";
        match = {
          class = "^steam$";
          title = "^Steam$";
        };
        float = true;
        center = true;
        size = [1100 700];
      }
      {
        name = "steam-friends-float";
        match = {
          class = "^steam$";
          title = "^Friends List$";
        };
        float = true;
        size = [460 800];
      }
      {
        name = "steam-games-fullscreen";
        match.class = "^steam_app_[0-9]+$";
        fullscreen = true;
        content = "game";
      }
      {
        name = "share-picker-float";
        match.title = "^Select what to share$";
        float = true;
        center = true;
      }
    ];
  };
}
