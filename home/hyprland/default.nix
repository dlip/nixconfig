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
    playerctl
    brightnessctl
    sway-contrib.grimshot
    grimblast
    cliphist
    fuzzel
    swayidle
    udiskie
    overskride
    hypridle
    libnotify
    hyprlock
  ];
}
