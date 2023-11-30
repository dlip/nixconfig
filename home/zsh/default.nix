{pkgs, ...}: {
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
      ls = "lsd";
      lg = "lazygit";
      # find = "fd";
      grc = "git reset $(git merge-base HEAD origin/main)";
      rt = "zellij action rename-tab";
      zj = "zellij";
    };

    initExtra = ''
      # [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      export MANWIDTH=999
      export FZF_DEFAULT_COMMAND='fd'
      export GPG_TTY="$(tty)"
      export XDG_DATA_HOME="$HOME/.local/share"
      # gpg-connect-agent /bye
      # export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      # Needed for go debugging
      export CGO_CFLAGS=-O

      if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
        export TERM="xterm-256color"
      fi
      source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      source "${pkgs.repo-catppuccin-zsh-syntax-highlighting}/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "brew"
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
