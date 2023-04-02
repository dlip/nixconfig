{ config, pkgs, ... }: {
  home.packages = [ pkgs.unstable.helix ];

  home.file = {
    "${config.xdg.configHome}/helix/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/helix/config.toml";
    "${config.xdg.configHome}/helix/languages.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/helix/languages.toml";
  };
}
