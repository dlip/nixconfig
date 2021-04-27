{ pkgs, ... }:
{
  programs.doom-emacs = {
    enable = true;
    doomPrivateDir = ./dotfiles/doom.d;
  };
}
