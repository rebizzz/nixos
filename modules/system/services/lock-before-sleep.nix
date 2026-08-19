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
      before = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
      wantedBy = ["sleep.target" "suspend.target" "hibernate.target" "hybrid-sleep.target"];
      serviceConfig = {
        Type = "oneshot";
        User = user.name;
        Environment = "XDG_RUNTIME_DIR=/run/user/${toString user.uid}";
        # caelestia's lock IPC target -- verify with `caelestia shell lock lock`
        # after switching; this is inferred from the shell's documented IPC
        # surface (`caelestia shell <target> <function>`), not directly
        # confirmed against a running instance.
        ExecStart = "${inputs.caelestia-cli.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/caelestia shell lock lock";
        TimeoutStartSec = "10s";
      };
    };
  };
}
