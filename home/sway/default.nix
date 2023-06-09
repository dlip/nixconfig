{
  pkgs,
  config,
  ...
}: {
  home.file = {
    "${config.xdg.configHome}/sway/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/sway/config";
    "${config.xdg.configHome}/kanshi/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/sway/kanshi";
  };
}
