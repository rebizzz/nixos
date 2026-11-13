_: {
  flake.modules.homeManager.micro = _: {
    programs.micro = {
      enable = true;
      settings = {
        tabsize = 2;
        tabstospaces = true;
        autoindent = true;
        cursorline = true;
        ruler = true;
        statusline = true;
        diffgutter = true;
        autosu = true;
        mkparents = true;
        matchbrace = true;
        parsecursor = true;
        softwrap = true;
        wordwrap = true;
        saveundo = true;
        eofnewline = true;
      };
    };

    xdg.configFile."micro/settings.json".force = true;

    home.sessionVariables = {
      EDITOR = "micro";
      VISUAL = "micro";
    };
  };
}
