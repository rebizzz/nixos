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

      nano = {
        enable = true;
        syntaxHighlight = true;
        nanorc = ''
          set autoindent
          set linenumbers
          set mouse
          set tabsize 4
          set tabstospaces
          set titlecolor white,blue
          set statuscolor white,green
          set selectedcolor white,magenta
          set numbercolor cyan
          set keycolor yellow
          set functioncolor sky
        '';
      };
    };

    environment.systemPackages = [
      pkgs.fastfetch
      pkgs.sops
    ];
  };
}
