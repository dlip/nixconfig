{ config, lib, pkgs, ... }:

with lib;
{
  options.home = {
    name = mkOption {
      type = types.str;
      default = "Dane Lipscombe";
    };
    email = mkOption {
      type = types.str;
      default = "danelipscombe@gmail.com";
    };
  };


  imports = [
    #./emacs
    ./bash
    ./files
    ./fonts.nix
    ./git
    ./gpg-agent
    ./lsp.nix
    ./neovim
    ./nnn
    ./packages.nix
    ./readline
    ./starship
    ./tmux
    ./version.nix
    ./zsh
  ];
}
