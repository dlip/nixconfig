{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.unstable.mpv];

  home.file = {
    "${config.xdg.configHome}/mpv/mpv.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/mpv/mpv.conf";
  };
}