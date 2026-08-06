_: let
  avatar = ../../../assets/avatar.jpeg;
  accountsServiceIcon = "/var/lib/AccountsService/icons/rebiz";
  accountsServiceUserPath = "/var/lib/AccountsService/users/rebiz";
in {
  flake.modules.nixos.user = {
    pkgs,
    config,
    ...
  }: {
    time.timeZone = "Asia/Kolkata";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = ["en_US.UTF-8/UTF-8"];

    programs.fish.enable = true;

    users.users.rebiz = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.user_password.path;
      extraGroups = ["wheel" "networkmanager" "video" "audio" "input" "libvirtd"];
      shell = pkgs.fish;
    };

    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

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
}
