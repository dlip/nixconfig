{
  pkgs,
  config,
  ...
}: {
  home.file = {
    "${config.xdg.configHome}/i3/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/i3/config";
  };
}
