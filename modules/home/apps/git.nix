_: {
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      ignores = [
        "result"
        "result-*"
        ".direnv/"
        ".envrc.cache"
        "*.swp"
        "*~"
      ];
      settings = {
        user.name = "rebiz";
        user.email = "1296550727652610189+rebizzz@users.noreply.github.com";
        pull.rebase = true;
        rebase.autoStash = true;
        merge.conflictstyle = "zdiff3";
        init.defaultBranch = "main";
        core.editor = "nano";
        diff.colorMoved = "zebra";
        push.autoSetupRemote = true;
        fetch.prune = true;
        rerere.enabled = true;
      };
    };
  };
}
