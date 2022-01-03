{ pkgs, config, ... }: {
  home.file = {
    ".config/espanso/default.yml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/espanso.yaml";
    };
  };
}
