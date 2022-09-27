{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.home;
in
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
    xrandrCommand = mkOption {
      type = types.str;
      default = "";
    };
  };

  imports = [
    #./emacs
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
    ./syncthing
    ./tmux
    ./zsh
  ];
}
