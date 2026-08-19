_: let
  avatar = ../../../assets/avatar.jpeg;
in {
  flake.modules.nixos.user = {
    pkgs,
    config,
    lib,
    ...
  }: let
    userName = config.myConfig.user.name;
    accountsServiceIcon = "/var/lib/AccountsService/icons/${userName}";
    accountsServiceUserPath = "/var/lib/AccountsService/users/${userName}";
  in {
    options.myConfig.user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "rebiz";
        description = "Primary username for the system";
      };
      home = lib.mkOption {
        type = lib.types.path;
        default = "/home/rebiz";
        description = "Primary user home directory";
      };
    };

    config = {
      time.timeZone = "Asia/Kolkata";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

      programs.fish.enable = true;

      users = {
        mutableUsers = false;

        users.${userName} = {
          isNormalUser = true;
          extraGroups = ["wheel" "networkmanager" "video" "audio" "input" "docker" "storage" "render"];
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID9CvwTALuQuiHJlkXTs2U5SKMhiu/lag3jQsbBIyHCl guardiansofspartax@gmail.com"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINVKdJ2d/APmJOYmjZtggs39BmS1sF96wJnwoEc0ErQQ guardiansofspartax@gmail.com"
          ];
        };

        # locked out, not just passwordless: use sudo via the wheel group instead
        users.root.hashedPassword = "!";
      };

      security.sudo-rs = {
        enable = true;
        extraConfig = ''
          Defaults lecture = never
        '';
      };

      systemd.tmpfiles.rules = [
        "L+ ${accountsServiceIcon} - - - - ${avatar}"
      ];

      system.activationScripts.accountsServiceUser.text = ''
        mkdir -p /var/lib/AccountsService/users
        cat > ${accountsServiceUserPath} << 'EOF'
        [User]
        Icon=${accountsServiceIcon}
        SystemAccount=false
        EOF
        chmod 0600 ${accountsServiceUserPath}
      '';
    };
  };
}
