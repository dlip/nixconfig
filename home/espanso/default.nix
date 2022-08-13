{ pkgs, config, ... }: {

  services.espanso = {
    enable = true;
    package = pkgs.myEspanso;
  };
  home.file = {
    ".config/espanso/config" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config/config";
    };
    ".config/espanso/match" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config/match";
    };
  };
}
