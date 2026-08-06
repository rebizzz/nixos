_: {
  flake.modules.nixos.nano = {
    programs.nano = {
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
}
