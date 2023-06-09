{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [waybar];
  home.file = {
    "${config.xdg.configHome}/waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/waybar/config";
  };
}
