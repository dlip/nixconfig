{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.yazi];

  home.file = {
    "${config.xdg.configHome}/yazi".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/yazi/config";
  };
}
