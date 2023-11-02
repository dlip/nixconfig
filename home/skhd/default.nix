{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs.unstable; [skhd];
  home.file = {
    "${config.xdg.configHome}/skhd/skhdrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/skhd/skhdrc";
  };
}
