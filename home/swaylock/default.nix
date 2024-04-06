{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [swaylock];
  home.file = {
    "${config.xdg.configHome}/swaylock/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/swaylock/config";
  };
}
