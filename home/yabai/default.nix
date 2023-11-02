{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs.unstable; [yabai];
  home.file = {
    "${config.xdg.configHome}/yabai/yabairc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/yabai/yabairc";
  };
}
