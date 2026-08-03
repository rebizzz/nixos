_: {
  flake.modules.nixos.tools = {pkgs, ...}: {
    programs.git = {
      enable = true;
      config.safe.directory = ["/home/rebiz/opt/nixos-config"];
    };
    environment.systemPackages = [
      pkgs.fastfetch
      pkgs.age
      pkgs.sops
    ];
  };
}
