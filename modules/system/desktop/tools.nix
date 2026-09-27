_: {
  flake.modules.nixos.tools = {
    pkgs,
    config,
    ...
  }: {
    programs = {
      git = {
        enable = true;
        config.safe.directory = ["${config.myConfig.user.home}/opt/nixos-config"];
      };

      nano.enable = false;
    };

    environment.systemPackages = [
      pkgs.fastfetch
      pkgs.sops
    ];
  };
}
