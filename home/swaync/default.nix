{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [swaynotificationcenter];
  home.file = {
    "${config.xdg.configHome}/swaync/config.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/swaync/config.json";
  };
}
