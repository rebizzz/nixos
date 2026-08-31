_: {
  flake.modules.nixos.tools = {
    pkgs,
    config,
    ...
  }: {
    programs.git = {
      enable = true;
      config.safe.directory = ["${config.myConfig.user.home}/opt/nixos-config"];
    };
    environment.systemPackages = [
      pkgs.fastfetch
      pkgs.age
      pkgs.sops
    ];
  };
}
