_: {
  flake.modules.nixos.secrets = _: {
    sops = {
      defaultSopsFile = ../../../secrets/secrets.yaml;
      age.keyFile = "/persistent/etc/sops/age/keys.txt";

      secrets = {
        user_password.neededForUsers = true;
      };
    };
  };
}
