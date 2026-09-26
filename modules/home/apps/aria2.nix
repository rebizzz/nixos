_: {
  flake.modules.homeManager.aria2 = {config, ...}: {
    programs.aria2 = {
      enable = true;
      systemd.enable = false;

      settings = {
        dir = "${config.home.homeDirectory}/Downloads";
        continue = true;
        max-concurrent-downloads = 3;
        split = 4;
        max-connection-per-server = 4;
        min-split-size = "1M";

        enable-dht = true;
        enable-dht6 = true;
        enable-peer-exchange = true;
        bt-enable-lpd = true;
        bt-max-peers = 100;
        bt-request-peer-speed-limit = "0";

        listen-port = "6881-6999";
        dht-listen-port = "6881-6999";

        bt-save-metadata = true;
        bt-load-saved-metadata = true;
        bt-remove-unselected-file = true;

        disk-cache = "64M";
        file-allocation = "falloc";
        enable-mmap = true;
        check-integrity = true;

        seed-ratio = 1.0;
        bt-tracker-connect-timeout = 10;
        bt-tracker-timeout = 10;

        save-session = "${config.home.homeDirectory}/.local/state/aria2/session.txt";
        save-session-interval = 30;
      };
    };

    programs.fish.functions.aria2c = ''
      if test (count $argv) -eq 0
        if test -s "$HOME/.local/state/aria2/session.txt"
          command aria2c -i "$HOME/.local/state/aria2/session.txt"
        else
          command aria2c -h
        end
      else
        command aria2c $argv
      end
    '';
  };
}
