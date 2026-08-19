_: {
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      settings = {
        user.name = "rebiz";
        user.email = "1296550727652610189+rebizzz@users.noreply.github.com";
        pull.rebase = true;
        init.defaultBranch = "main";
        core.editor = "nano";
        diff.colorMoved = "zebra";
        push.autoSetupRemote = true;
        rerere.enabled = true;
      };
    };
  };
}
