{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.home = {
    name = mkOption {
      type = types.str;
      default = "Dane Lipscombe";
    };
    email = mkOption {
      type = types.str;
      default = "danelipscombe@gmail.com";
    };
    os = mkOption {
      type = types.str;
      default = "linux";
    };
  };

  imports = [
    #./emacs
    ./bash
    ./files
    ./fonts.nix
    ./git
    #./gpg-agent
    ./helix
    ./lazygit
    ./lsp.nix
    # ./neovim
    ./nnn
    ./packages.nix
    ./readline
    ./session.nix
    ./starship
    ./tmux
    ./version.nix
    ./zellij
    ./zsh
  ];
}
