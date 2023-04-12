{ config, pkgs, ... }: {
  home.packages = [ pkgs.unstable.zellij ];

  home.file = {
    "${config.xdg.configHome}/zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/zellij/config.kdl";
    "${config.xdg.configHome}/zellij/layouts".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/zellij/layouts";
  };
}