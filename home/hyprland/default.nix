{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../waybar
    ../swaylock
  ];

  home.file = {
    "${config.xdg.configHome}/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/hyprland.conf";
    "${config.xdg.configHome}/hypr/macchiato.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/macchiato.conf";
  };

  home.packages = with pkgs; [
    playerctl
    brightnessctl
    sway-contrib.grimshot
    grimblast
    cliphist
    fuzzel
    swayidle
  ];
}
