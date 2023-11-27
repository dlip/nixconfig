{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.mpv];

  home.file = {
    "${config.xdg.configHome}/mpv".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/mpv/config";
  };
}
