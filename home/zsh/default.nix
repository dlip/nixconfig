{
  pkgs,
  config,
  ...
}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;

    history = {
      ignoreDups = true;
      save = 1000000;
      size = 1000000;
    };

    initExtraFirst = ''
      # https://github.com/ohmyzsh/ohmyzsh/issues/6338
      export DISABLE_MAGIC_FUNCTIONS=true
    '';

    initExtra = ''
      # [ -f $HOME/.nix-profile/etc/profile.d/nix.sh ] && source $HOME/.nix-profile/etc/profile.d/nix.sh
      export MANPAGER="sh -c 'col -bx | bat -l man -p'"
      export MANROFFOPT="-c"
      export MANWIDTH=999
      export FZF_DEFAULT_COMMAND='fd'
      export GPG_TTY="$(tty)"
      export XDG_DATA_HOME="$HOME/.local/share"
      # gpg-connect-agent /bye
      # export SSH_AUTH_SOCK="/run/user/$UID/gnupg/S.gpg-agent.ssh"
      # Needed for go debugging
      export CGO_CFLAGS=-O

      source "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
      source "${pkgs.repo-catppuccin-zsh-syntax-highlighting}/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh"
      source "${config.home.homeDirectory}/code/nixconfig/bin/aliases"
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
