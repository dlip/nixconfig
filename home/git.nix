{ email, name, ... }:
{ ... }: {
  programs.git = {
    enable = true;

    userEmail = email;
    userName = name;

    extraConfig = {
      init.defaultBranch = "main";
      core = {
        pager = "less -R";
        autocrlf = "input";
        editor = "nvim";
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
