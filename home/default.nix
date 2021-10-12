{ configName, config }:
[
  #./emacs.nix
  ./espanso.nix
  ./files
  ./fonts.nix
  (import ./git.nix config)
  ./neovim
  ./packages.nix
  ./readline.nix
  ./starship.nix
  ./services.nix
  ./tmux.nix
  (import ./zsh.nix (config // {
    inherit configName;
  }))
]
