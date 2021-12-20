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
    #./emacs
    ./espanso
    ./files
    ./fonts.nix
    ./git
    ./gpg-agent
    ./neovim
    ./nnn
    ./packages.nix
    ./readline
    ./starship
    ./syncthing
    ./tmux
    ./zsh
  ] ++ (if !pkgs.stdenv.hostPlatform.isAarch64 then [
    ./desktop.nix
    ./lsp.nix
  ] else [ ]);
}
