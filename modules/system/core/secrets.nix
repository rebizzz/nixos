_: {
  flake.modules.nixos.secrets = {config, ...}: {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.keyFile = "/persistent/etc/sops/age/keys.txt";
      age.sshKeyPaths = ["/persistent/etc/ssh/ssh_host_ed25519_key"];

      secrets = {
        user_password_laptop.neededForUsers = true;
        user_password_server.neededForUsers = true;
        wifi_psk = {};
      };

      templates."network-manager.env".content = ''
        WIFI_PSK=${config.sops.placeholder.wifi_psk}
      '';
    };
  };
}
