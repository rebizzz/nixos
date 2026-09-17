_: {
  programs.umbriel.settings = {
    window_rule = [
      {
        blur = true;
        blur_optimized = false;
        opacity = 0.95;
      }
      {
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }
      {
        match.is_alone = true;
        default_maximize = true;
      }

      {
        match.app_id = "^(kitty|equibop|Equibop|org\\.quickshell|feh|imv|swappy|org\\.kde\\.krita|krita|gimp.*|org\\.inkscape\\.Inkscape|darktable|resolve|org\\.kde\\.kdenlive|shotcut|blender|godot|mpv|org\\.kde\\.haruna|haruna|steam_app_[0-9]+|steam_app_default|gamescope|brave-origin|brave-browser|brave|firefox|zen|zen-browser|chromium|google-chrome)$";
        opacity = 1.0;
        blur = false;
      }
      {
        match.title = "^(Open File|Open Folder|(Select|Open)( a)? (File|Folder)s?|Select|Choose a wallpaper|Save As|Library|Choose Where to Download|(Save|Export) Image)";
        default_floating = true;
        default_floating_size = {
          width = 0.6;
          height = 0.7;
        };
      }
      {
        match.title = "^(File (Operation|Upload)( Progress)?|.* Properties|Rename|Copy Files|Move Files|Search Files)";
        default_floating = true;
      }
      {
        match.app_id = "^(lxqt-policykit.*|udiskie|org\\.gnome\\.seahorse\\.Application)$";
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }
      {
        match = {
          app_id = "^(equibop|Equibop)$";
          title = "Discord";
        };
        default_scratchpad = "communication";
        default_floating_size = {
          width = 0.8;
          height = 0.85;
        };
      }
      {
        match.app_id = "^(discord|vesktop|whatsapp.*)$";
        default_scratchpad = "communication";
        default_floating_size = {
          width = 0.8;
          height = 0.85;
        };
      }
      {
        match.app_id = "^(spotify|Spotify|feishin|Supersonic|Plexamp|Cider|com\\.github\\.th-ch\\.youtube-music|com-maxrave-simpmusic-MainKt)$";
        default_scratchpad = "music";
        default_floating_size = {
          width = 0.8;
          height = 0.85;
        };
      }
      {
        match.app_id = "^btop$";
        default_scratchpad = "sysmon";
        default_floating_size = {
          width = 0.8;
          height = 0.85;
        };
      }
      {
        match.app_id = "^(todoist|Todoist)$";
        default_scratchpad = "todo";
        default_floating_size = {
          width = 0.8;
          height = 0.85;
        };
      }
      {
        match.app_id = "^(brave-origin|brave-browser|brave)$";
        default_maximize = true;
      }
      {
        match.app_id = "^dev\\.noctalia\\.Noctalia$";
        default_floating = true;
        default_floating_size_px = {
          width = 1020;
          height = 900;
        };
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
        blur_popups = false;
      }
      {
        match.app_id = "^dev\\.noctalia\\.UmbrielSharePicker$";
        default_floating = true;
        default_floating_size_px = {
          width = 800;
          height = 600;
        };
      }
      {
        match.app_id = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol|com\\.saivert\\.pwvucontrol|yad-icon-browser)$";
        default_floating = true;
        default_floating_size = {
          width = 0.6;
          height = 0.7;
        };
      }
      {
        match.app_id = "^(nm-connection-editor|blueman-manager|org\\.gnome\\.Nm-connection-editor|Emulator|zenity|yad|qalculate-gtk|guifetch|wev|org\\.gnome\\.FileRoller|file-roller|feh|imv|swappy|org\\.quickshell)$";
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
      }
      {
        match.app_id = "^(nwg-look|system-config-printer)$";
        default_floating = true;
        default_floating_size = {
          width = 0.5;
          height = 0.6;
        };
      }
      {
        match.app_id = "^org\\.gnome\\.Settings$";
        default_floating = true;
        default_floating_size = {
          width = 0.7;
          height = 0.8;
        };
      }
      # Browsers expose no semantic PiP role or global position control.
      {
        match.title = "^(Picture-in-Picture|Picture in picture)$";
        default_floating = true;
        default_maximize = false;
        default_pinned = true;
        default_position = {
          anchor = "bottom_right";
          x = 20;
          y = 20;
        };
      }
      {
        match.app_id = "^(xdg-desktop-portal(-.*)?|org\\.freedesktop\\.impl\\.portal\\.desktop\\..*)$";
        default_floating = true;
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
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
        default_floating_size_px = {
          width = 1100;
          height = 700;
        };
      }
      {
        match = {
          app_id = "^steam$";
          title = "^Friends List$";
        };
        default_floating = true;
        default_floating_size_px = {
          width = 460;
          height = 800;
        };
        default_position = {
          anchor = "center";
          x = 0;
          y = 0;
        };
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
      # Keep Steam notification toasts in the bottom-right corner without stealing
      # focus, and pin them so workspace switches do not hide them.
      {
        match.title = "^notificationtoasts_.+_desktop";
        default_position = {
          anchor = "bottom_right";
          x = 0;
          y = 0;
        };
        default_focused = false;
        default_pinned = true;
      }
    ];

    layer_rule = [
      {
        match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|window-switcher|desktop-widget-[^\"]*)$";
        blur = true;
        blur_ignore_alpha = 0.5;
        blur_optimized = false;
        blur_popups = true;
      }
    ];
  };
}
