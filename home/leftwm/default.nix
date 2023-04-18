{
  config,
  pkgs,
  ...
}: {
  home.file."${config.xdg.configHome}/leftwm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/leftwm/config";
  home.file."${config.xdg.configHome}/eww".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/leftwm/config/themes/basic_eww/eww-bar";

  home.packages = with pkgs.unstable; [
    eww
  ];
}
