_: {
  flake.modules.nixos.nfs = {
    config,
    lib,
    hostVars,
    ...
  }:
    lib.mkIf (config.myConfig.hostClass == "server") {
      # ── NFS server ────────────────────────────────────────────────────────
      services.nfs.server = {
        enable = true;
        # Pin auxiliary ports so the firewall rules below are deterministic.
        lockdPort = 4045;
        statdPort = 4046;
        mountdPort = 4047;
        exports = ''
          /mnt/data/shared ${hostVars.network.lanIp}/24(rw,sync,no_subtree_check,no_root_squash)
        '';
      };

      # ── Firewall ──────────────────────────────────────────────────────────
      networking.firewall = {
        allowedTCPPorts = [
          2049 # NFS
          111 # portmapper / rpcbind
          4045 # lockd
          4046 # statd
          4047 # mountd
        ];
        allowedUDPPorts = [
          2049
          111
          4045
          4046
          4047
        ];
      };
    };
}
