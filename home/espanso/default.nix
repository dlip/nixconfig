{ pkgs, config, ... }: {
  home.file = {
    ".config/espanso" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config";
    };
  };
}
