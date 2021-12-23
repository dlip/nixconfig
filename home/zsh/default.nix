{ config, pkgs, lib, ... }:
{
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
      n = "nnn";
      ren = "qmv -f do";
      v = "nvim";
      x = "xplr";
    };

    initExtra = ''
      [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      export EDITOR=nvim
      export GOPATH=$HOME/go
      export PATH=$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      export MANPAGER='nvim +Man!'
      export MANWIDTH=999
      export FZF_DEFAULT_COMMAND='fd'
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      # Needed for go debugging
      export CGO_CFLAGS=-O
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
      ];
    };
  };
}
