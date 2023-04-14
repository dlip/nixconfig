{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs.unstable; [k9s popeye];

  home.file = {
    "${config.xdg.configHome}/k9s/skin.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/k9s/skin.yml";
  };
}
