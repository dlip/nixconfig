{ configName, nixConfigPath, ... }:
{ pkgs, lib, ... }:
let aliases = builtins.readFile ./dotfiles/aliases.sh;
in {
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
      g = "git";
    };

    initExtra = ''
      [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      export EDITOR=nvim
      export GOPATH=$HOME/go
      export PATH=$HOME/bin:$HOME/.local/bin:$GOPATH/bin:$PATH

      export NIXCONFIG=${configName}
      export GPG_TTY="$(tty)"
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
    '' + aliases;

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
        "vi-mode"
        "yarn"
        "zsh-navigation-tools"
        "urltools"
      ];
    };
  };
}
