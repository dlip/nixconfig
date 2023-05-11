{...}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history = {
      ignoreDups = true;
      save = 1000000;
      size = 1000000;
    };

    shellAliases = {
      c = "clear";
      clip = "xclip -sel c";
      g = "git";
      h = "hx";
      n = "nnn";
      ren = "qmv -f do";
      s = "rg --files-with-matches";
      v = "nvim";
      x = "xplr";
      ls = "exa";
      lg = "lazygit";
      # find = "fd";
      grc = "git reset $(git merge-base HEAD origin/main)";
      rt = "zellij action rename-tab";
      zj = "zellij";
    };

    initExtra = ''
      # [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      export EDITOR=hx
      export GOPATH=$HOME/go
      export PATH=$HOME/code/nixconfig/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin:$PATH
      export LANG=en_AU.UTF-8
      export LC_ALL=en_AU.UTF-8
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      export MANWIDTH=999
      export FZF_DEFAULT_COMMAND='fd'
      export GPG_TTY="$(tty)"
      # gpg-connect-agent /bye
      # export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      # Needed for go debugging
      export CGO_CFLAGS=-O

      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        export TERM="xterm-256color"
      fi
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "docker"
        "direnv"
        "encode64"
        "git"
        "git-extras"
        "kubectl"
        "man"
        "nmap"
        "sudo"
        "systemd"
        "tig"
        "yarn"
        "zsh-navigation-tools"
        "urltools"
        "zoxide"
      ];
    };
  };
}
