{inputs, ...}: let
  hostVars = import ./_host.nix {};
  system = "x86_64-linux";

  pkgs = import inputs.nixpkgs {inherit system;};

  deployPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      inputs.deploy-rs.overlays.default
      (_final: super: {
        deploy-rs = {
          inherit (pkgs) deploy-rs;
          lib = super.deploy-rs.lib;
        };
      })
    ];
  };
in {
  flake.nixosConfigurations.${hostVars.hostName} = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs hostVars;};
    modules = [
      inputs.self.modules.nixos.base
      inputs.self.modules.nixos.autoupgrade
      inputs.self.modules.nixos.zfs
      inputs.self.modules.nixos.containers
      inputs.self.modules.nixos.motd
      inputs.self.modules.nixos.networking
      inputs.self.modules.nixos.security
      inputs.self.modules.nixos.persistence-server
      inputs.self.modules.nixos.power-server
      inputs.self.modules.nixos.services-server
      # Jellyfin is opt-in: uncomment to enable media serving on this host.
      # inputs.self.modules.nixos.media
      ./_disko.nix
      ./_hardware.nix
      ({
        config,
        pkgs,
        ...
      }: {
        boot.loader = {
          systemd-boot = {
            enable = true;
            configurationLimit = 10;
          };
          timeout = 3;
          efi.canTouchEfiVariables = true;
        };

        system.stateVersion = "26.05";

        users.users.rebiz.hashedPasswordFile = config.sops.secrets.user_password_server.path;

        security.sudo-rs.wheelNeedsPassword = false;
        security.sudo-rs.execWheelOnly = true;

        environment.systemPackages = with pkgs; [
          git
          nano
          curl
          wget
          pciutils
          usbutils
          btrfs-progs
          e2fsprogs
          hdparm
          smartmontools
          lm_sensors
          nh
        ];
      })
    ];
  };

  flake.deploy.nodes.${hostVars.hostName} = {
    hostname = "${hostVars.hostName}.local";
    sshUser = "rebiz";
    sshOpts = ["-o" "StrictHostKeyChecking=accept-new"];
    fastConnection = true;
    autoRollback = true;
    magicRollback = true;
    profiles.system = {
      user = "root";
      path =
        deployPkgs.deploy-rs.lib.activate.nixos
        inputs.self.nixosConfigurations.${hostVars.hostName};
    };
  };
}
