_: {
  flake.modules.homeManager.kitty = {
    config,
    lib,
    ...
  }: let
    themeFile = "${config.xdg.configHome}/kitty/themes/noctalia.conf";
  in {
    programs.kitty = {
      enable = true;

      font = {
        name = "FiraCode Nerd Font";
        size = 12.5;
      };

      settings = {
        repaint_delay = 6;
        input_delay = 1;
        sync_to_monitor = "yes";
        linux_display_server = "wayland";
        background_opacity = "0.85";
        window_padding_width = 8;
        cursor_shape = "block";
        cursor_blink_interval = 0;
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        scrollback_lines = 10000;
      };

      extraConfig = ''
        include themes/noctalia.conf
      '';
    };

    # `include themes/noctalia.conf` requires the file to exist.
    # Noctalia writes this template on theme generation.
    home.activation.kittyNoctaliaTheme = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      if [ ! -e "${themeFile}" ]; then
        run mkdir -p $VERBOSE_ARG "$(dirname "${themeFile}")"
        run tee "${themeFile}" >/dev/null <<'FALLBACK'
background #0e1415
foreground #dde4e3
FALLBACK
      fi
    '';
  };
}
