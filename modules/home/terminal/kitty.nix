_: {
  flake.modules.homeManager.kitty = {...}: {
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
  };
}
