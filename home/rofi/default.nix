{
  pkgs,
  config,
  ...
}: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./rofi.theme.rasi;
    font = "RobotoMono Nerd Font 10";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus";
      display-drun = "";
      disable-history = false;
      sidebar-mode = false;
    };
  };
}
