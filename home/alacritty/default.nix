{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [alacritty];
  home.file = {
    "${config.xdg.configHome}/alacritty/alacritty.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/alacritty/alacritty.yml";
  };
}
