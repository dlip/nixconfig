{ configName, ... }:
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
      source $HOME/.nix-profile/etc/profile.d/nix.sh
      export PATH=$HOME/bin:$HOME/go/bin:$PATH
      export NIXCONFIG=${configName}
    '' + aliases;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "aws"
        "docker"
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
