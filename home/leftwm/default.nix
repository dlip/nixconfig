{
  config,
  pkgs,
  ...
}: {
  home.file."${config.xdg.configHome}/leftwm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/leftwm/config";
}
