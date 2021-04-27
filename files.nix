{ ... }: {
  home.file = {

    # tmux theme
    ".palenight-tmux".source = ./dotfiles/palenight-tmux;

    #  ".config/starship.toml".text = ''
    #   [nix_shell]
    #   use_name = false
    # '';
  };
}
