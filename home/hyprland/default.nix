{
  pkgs,
  config,
  ...
}: {
  home.file = {
    "${config.xdg.configHome}/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/hyprland.conf";
  };
}
