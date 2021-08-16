{ ... }: {
  home.file = {

    # tmux theme
    ".palenight-tmux".source = ./palenight-tmux;
    ".config/networkmanager-dmenu".source = ./networkmanager-dmenu;

    #  ".config/starship.toml".text = ''
    #   [nix_shell]
    #   use_name = false
    # '';
  };
}
