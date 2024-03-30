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
    "${config.xdg.configHome}/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/config";
  };

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    fuzzel
    grimblast
    hypridle
    hyprlock
    hyprpaper
    libnotify
    playerctl
    sway-contrib.grimshot
    swayidle
    udiskie
  ];
}
