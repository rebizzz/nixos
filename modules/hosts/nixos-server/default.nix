{inputs, ...}: let
  hostVars = import ./_host.nix {};

  system = "x86_64-linux";
  pkgs = import inputs.nixpkgs {inherit system;};
  # Use the nixpkgs binary cache for deploy-rs instead of building it from
  # the flake: keep the flake's lib (activate.nixos etc.), but take the CLI
  # derivation embedded in the activation script from nixpkgs.
  deployPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      inputs.deploy-rs.overlays.default
      (_: super: {
        deploy-rs = {
          inherit (pkgs) deploy-rs;
          lib = super.deploy-rs.lib;
        };
      })
    ];
  };

  modules = [
    inputs.self.modules.nixos.server-profile
    ./_disko.nix
    ./_hardware.nix
    ({
      config,
      pkgs,
      ...
    }: {
      myConfig.hostClass = "server";

      boot.loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 10;
        };
        timeout = 3;
        efi.canTouchEfiVariables = true;
      };

      system.stateVersion = "26.05";

      users.users.${config.myConfig.user.name}.hashedPasswordFile = config.sops.secrets.user_password_server.path;

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
        microfetch
        kitty.terminfo # fix "unknown terminal type" for xterm-kitty SSH sessions
      ];
    })
  ];
in {
  flake = {
    nixosConfigurations.${hostVars.hostName} = inputs.nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs hostVars;};
      inherit modules;
    };

    deploy.nodes.${hostVars.hostName} = {
      hostname = "${hostVars.hostName}.local";
      inherit (hostVars) sshUser;
      sshOpts = ["-o" "StrictHostKeyChecking=accept-new"];
      remoteBuild = true; # build on the server instead of locally
      profiles.system = {
        user = "root";
        path = deployPkgs.deploy-rs.lib.activate.nixos inputs.self.nixosConfigurations.${hostVars.hostName};
      };
    };
  };
}
