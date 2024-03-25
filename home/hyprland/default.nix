{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../waybar
  ];

  home.file = {
    "${config.xdg.configHome}/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/hyprland.conf";
  };

  home.packages = with pkgs; [
    playerctl
    brightnessctl
    sway-contrib.grimshot
    grimblast
    cliphist
    fuzzel
  ];
}
