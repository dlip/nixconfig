{ config, ... }: {
  programs.zellij.enable = true;

  home.file = {
    "${config.xdg.configHome}/zellij/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/zellij/config.kdl";
  };
}
