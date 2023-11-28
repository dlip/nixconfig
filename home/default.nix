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
  };

  imports = [
    ./bash
    ./files
    ./fonts.nix
    ./git
    #./gpg-agent
    # ./helix
    ./lazygit
    ./lsp.nix
    # ./neovim
    ./nixvim.nix
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
