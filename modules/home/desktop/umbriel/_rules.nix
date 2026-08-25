_: {
  programs.umbriel.settings = {
    window_rule = [
      {
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }

      {
        match.app_id = "^kitty$";
        blur = true;
        opacity = 0.95;
      }
      {
        match.app_id = "^(com\\.gabm\\.satty|satty)$";
        default_floating = true;
      }
      {
        match.app_id = "^(lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)$";
        default_floating = true;
      }
      {
        match = {
          app_id = "^(vesktop|Vesktop)$";
          title = "^(?!Vesktop Updater$).*$";
        };
        default_maximize = true;
      }
      {
        match.title = "^Vesktop Updater$";
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }
      {
        match.app_id = "^(brave-browser|brave)$";
        default_maximize = true;
      }
      {
        match.app_id = "^dev\\.noctalia\\.Noctalia$";
        default_floating = true;
        default_size = [1020 900];
      }
      {
        match.app_id = "^dev\\.noctalia\\.UmbrielSharePicker$";
        default_floating = true;
        default_size = [800 600];
      }
      {
        match.app_id = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol|nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor)$";
        default_floating = true;
      }
      {
        match = {
          app_id = "^(brave|chromium).*";
          title = "^Picture-in-Picture$";
        };
        default_floating = true;
      }
      {
        match.app_id = "^(xdg-desktop-portal-.*|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)$";
        default_floating = true;
      }
      {
        match.app_id = "^mpv$";
        opacity = 1.0;
      }
      {
        match = {
          app_id = "^steam$";
          title = "^Steam$";
        };
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
        default_size = [1100 700];
      }
      {
        match = {
          app_id = "^steam$";
          title = "^Friends List$";
        };
        default_floating = true;
        default_size = [460 800];
      }
      {
        match.app_id = "^steam_app_[0-9]+$";
        default_fullscreen = true;
      }
      {
        match.title = "^Select what to share$";
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }
    ];

    layer_rule = [
      {
        match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher)$";
        blur = true;
      }
    ];
  };
}
