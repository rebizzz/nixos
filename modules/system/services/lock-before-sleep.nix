{inputs, ...}: {
  flake.modules.nixos.lock-before-sleep = {
    pkgs,
    config,
    ...
  }: let
    user = config.users.users.${config.myConfig.user.name};
  in {
    systemd.services.lock-before-sleep = {
      description = "Lock the session before suspend/hibernate";
      before = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
      wantedBy = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        User = user.name;
        Environment = "XDG_RUNTIME_DIR=/run/user/${toString (if user.uid != null then user.uid else 1000)}";
        ExecStart = "${inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/noctalia msg session lock";
        TimeoutStartSec = "10s";
      };
    };
  };
}
