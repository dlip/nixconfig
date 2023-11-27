{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [btop];

  home.file = {
    "${config.xdg.configHome}/btop".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/btop/config";
  };
}
