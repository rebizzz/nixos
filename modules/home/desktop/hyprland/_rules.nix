{lib, ...}: let
  vars = import ./_lib.nix {inherit lib;};
  inherit (vars) taggedRule taggedRuleRaw;
in {
  wayland.windowManager.hyprland.settings = {
    workspace_rule = [
      {workspace = "w[tv1]s[false]"; gaps_out = 20;}
      {workspace = "f[1]s[false]"; gaps_out = 20;}
    ];

    layer_rule = [
      {match.namespace = "hyprpicker"; animation = "fade";}
      {match.namespace = "logout_dialog"; animation = "fade";}
      {match.namespace = "selection"; animation = "fade";}
      {match.namespace = "wayfreeze"; animation = "fade";}
      {match.namespace = "launcher"; animation = "popin 80%"; blur = true;}
      {match.namespace = "caelestia-(border-exclusion|area-picker)"; no_anim = true;}
      {match.namespace = "caelestia-(drawers|background)"; animation = "fade";}
    ];

    window_rule =
      [
        {match.fullscreen = false; opacity = "0.95 override";}
        {match = {float = true; xwayland = false;}; center = true;}
        {
          match.title = "Picture(-| )in(-| )[Pp]icture";
          move = "(monitor_w*0.98-window_w) (monitor_h*0.97-window_h)";
          pin = true;
          float = true;
          keep_aspect_ratio = true;
        }
        {match.class = "ueberzugpp_.*"; float = true; no_initial_focus = true;}
      ]
      ++ taggedRule "opaque" "class" [
        "foot"
        "equibop"
        "org.quickshell"
        "feh|imv|swappy"
        "krita|gimp|inkscape|darktable"
        "resolve|kdenlive|shotcut"
        "blender|godot"
      ]
      ++ taggedRule "float" "class" [
        "guifetch"
        "yad|zenity"
        "wev"
        "org.gnome.FileRoller|file-roller"
        "blueman-manager"
        "feh|imv|swappy"
        "org.quickshell"
      ]
      ++ taggedRule "float" "title" [
        "File (Operation|Upload)( Progress)?"
        ".* Properties"
      ]
      ++ taggedRule "float_60_70" "title" [
        "(Select|Open)( a)? (File|Folder)(s)?"
        "Save As"
        "Library"
      ]
      ++ taggedRule "float_60_70" "class" [
        "org.pulseaudio.pavucontrol|com.saivert.pwvucontrol"
        "yad-icon-browser"
      ]
      ++ taggedRule "float_70_80" "class" ["org.gnome.Settings"]
      ++ taggedRule "float_50_60" "class" ["nwg-look" "system-config-printer"]
      ++ taggedRule "game" "class" ["steam_app_[0-9]+" "steam_app_default" "gamescope"]
      ++ taggedRule "system_monitor" "class" ["btop"]
      ++ taggedRule "music_player" "class" [
        "feishin|Supersonic|Plexamp"
        "Spotify"
        "Cider"
        "com.github.th-ch.youtube-music|com-maxrave-simpmusic-MainKt"
      ]
      ++ taggedRule "communication_app" "class" ["discord|equibop|vesktop" "whatsapp"]
      ++ taggedRule "todo_app" "class" ["todoist"]
      ++ taggedRuleRaw "xwl_popup" [
        {xwayland = true; title = "win[0-9]+";}
        {xwayland = true; title = ""; class = ""; initial_title = ""; initial_class = "";}
        {class = "steam"; title = "";}
      ]
      ++ taggedRuleRaw "float" [
        {class = "com-atlauncher-App"; title = "ATLauncher Console";}
        {class = "PandoraLauncher"; title = "Minecraft Game Output";}
      ]
      ++ [
        {_args = [{match = {class = "steam"; title = "Friends List";};} "+float"];}
        {match.class = "fusion360.exe"; match.title = "Fusion360|(Marking Menu)"; no_blur = true;}
        {match.tag = "opaque"; opaque = true;}
        {match.tag = "float"; float = true;}
        {match.tag = "float_50_60"; float = true; size = "(monitor_w*0.5) (monitor_h*0.6)"; center = true;}
        {match.tag = "float_60_70"; float = true; size = "(monitor_w*0.6) (monitor_h*0.7)"; center = true;}
        {match.tag = "float_70_80"; float = true; size = "(monitor_w*0.7) (monitor_h*0.8)"; center = true;}
        {match.tag = "game"; opaque = true; immediate = true; idle_inhibit = "always";}
        {match.tag = "system_monitor"; workspace = "special:sysmon";}
        {match.tag = "music_player"; workspace = "special:music";}
        {match.tag = "communication_app"; workspace = "special:communication";}
        {match.tag = "todo_app"; workspace = "special:todo";}
        {
          match.tag = "xwl_popup";
          no_dim = true;
          no_shadow = true;
          no_blur = true;
          opaque = true;
          rounding = 10; # min(10, windowRounding=15)
        }
      ];
  };
}
