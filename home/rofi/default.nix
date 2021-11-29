{ pkgs, config, ... }:

{
  programs.rofi = {
    enable = true;
    terminal = "${pkgs.alacritty}/bin/alacritty";
    theme = ./rofi.theme.rasi;
    font = "FiraCode Nerd Font 10";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus";
      display-drun = "";
      disable-history = false;
      sidebar-mode = false;
    };
  };
}
