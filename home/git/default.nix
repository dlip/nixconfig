{ config, ... }: {
  programs.git = {
    enable = true;

    userEmail = config.home.email;
    userName = config.home.name;

    extraConfig = {
      init.defaultBranch = "main";
      advice.detachedHead = false;
      core = {
        pager = "delta";
        autocrlf = "input";
        editor = "nvim";
      };
      interactive = { diffFilter = "delta --color-only --features=interactive"; };
      delta = {
        features = "decorations";
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
      };
      credential = { helper = "store"; };
      status = { showUntrackedFiles = "all"; };
      transfer = { fsckobjects = false; };
      push = { default = "current"; };
      pull = {
        rebase = false;
        default = "current";
      };
      color = { ui = true; };
      merge = {
        conflictstyle = "diff3";
        summary = true;
        tool = "nvim";
      };
      mergetool = {
        keepBackup = false;
      };
      "mergetool \"nvim\"".cmd = ''nvim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
      branch = { autoSetupMerge = "always"; };
      instaweb = { port = 1234; };
      ui = { color = true; };
      rebase = {
        stat = true;
        autoSquash = true;
        autostash = true;
      };
      stash = { showPatch = true; };
    };
    aliases = {
      st = "status";
      di = "diff";
      ci = "commit";
      br = "branch";
      sta = "stash";
      co = "checkout";
      cd = "checkout";
      cb = "checkout -b";
      rbom = "rebase -i origin/master";
      rbc = "rebase --continue";
      amend = "commit --amend";
      stat = "status -s";
      unadd = "rm --cached";
      dlog = "log --decorate";
      merge = "merge --no-edit";
    };
  };
}
