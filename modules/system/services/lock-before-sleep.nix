{inputs, ...}: {
  flake.modules.nixos.lock-before-sleep = {
    pkgs,
    config,
    ...
  }: let
    user = config.users.users.rebiz;
  in {
    systemd.services.lock-before-sleep = {
      description = "Lock the session before suspend/hibernate";
      before = ["sleep.target"];
      wantedBy = ["sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        User = user.name;
        Environment = "XDG_RUNTIME_DIR=/run/user/${toString user.uid}";
        ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia msg session lock";
      };
    };
  };
}
