{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.unstable.zellij];

  home.file = {
    "${config.xdg.configHome}/zellij".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/zellij/config";
  };
}
