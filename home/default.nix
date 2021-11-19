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
      default = "dane@lipscombe.com.au";
    };
    xrandrCommand = mkOption {
      type = types.str;
      default = "";
    };
  };

  imports = [
      #./emacs.nix
      ./espanso.nix
      ./files
      ./fonts.nix
      ./git.nix
      ./lsp.nix
      ./neovim
      ./nnn
      ./packages.nix
      ./readline.nix
      ./starship.nix
      ./services.nix
      ./tmux.nix
      ./zsh.nix
  ];
}
