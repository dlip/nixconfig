{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.unstable.lazygit];

  home.file = {
    "${config.xdg.configHome}/lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/lazygit/config.yml";
  };
}
