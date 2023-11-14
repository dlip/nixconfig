{
  config,
  pkgs,
  ...
}: {
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
      };
      interactive = {diffFilter = "delta --color-only --features=interactive";};
      delta = {
        features = "calochortus-lyallii";
        side-by-side = true;
      };
      credential = {
        helper =
          if pkgs.stdenv.isDarwin
          then "osxkeychain"
          else "store";
      };
      status = {showUntrackedFiles = "all";};
      transfer = {fsckobjects = false;};
      push = {default = "current";};
      pull = {
        rebase = false;
        default = "current";
      };
      color = {ui = true;};
      merge = {
        conflictstyle = "diff3";
        summary = true;
        tool = "nvim";
      };
      mergetool = {
        keepBackup = false;
      };
      "mergetool \"nvim\"".cmd = ''nvim -f -c "MergetoolStart" "$MERGED" "$BASE" "$LOCAL" "$REMOTE"'';
      branch = {autoSetupMerge = "always";};
      instaweb = {port = 1234;};
      ui = {color = true;};
      rebase = {
        stat = true;
        autoSquash = true;
        autostash = true;
      };
      stash = {showPatch = true;};
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
  home.file = {
    "${config.xdg.configHome}/git/ignore".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/git/ignore";
  };
}
