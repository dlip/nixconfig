{ configName, config }:
[
  ./emacs.nix
  ./files
  ./fonts.nix
  (import ./git.nix config)
  ./neovim.nix
  ./packages.nix
  ./starship.nix
  ./services.nix
  ./tmux.nix
  (import ./zsh.nix (config // {
    inherit configName;
  }))
]
