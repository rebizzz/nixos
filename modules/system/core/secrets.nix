_: {
  flake.modules.nixos.secrets = {config, ...}: {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.keyFile = "/persistent/etc/sops/age/keys.txt";

      secrets = {
        user_password.neededForUsers = true;
        wifi_psk = {};
      };

      templates."network-manager.env".content = ''
        WIFI_PSK=${config.sops.placeholder.wifi_psk}
      '';
    };
  };
}
