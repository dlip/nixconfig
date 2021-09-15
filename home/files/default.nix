{ ... }: {
  home.file = {

    # tmux theme
    ".palenight-tmux".source = ./palenight-tmux;
    ".config/networkmanager-dmenu".source = ./networkmanager-dmenu;
    ".config/feh/themes".text = ''
      feh --reverse --auto-rotate --fullscreen
    '';

    ".config/feh/buttons".text = ''
      # make scroll wheel (mousewheel up and down) zoom, instead of flipping images
      zoom_in 4
      zoom_out 5
    '';

    ".config/zathura/zathurarc".text = ''
      set selection-clipboard clipboard
    '';

    #  ".config/starship.toml".text = ''
    #   [nix_shell]
    #   use_name = false
    # '';
  };
}
