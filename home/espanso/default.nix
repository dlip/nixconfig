{ pkgs, config, ... }: {

  services.espanso = {
    enable = true;
    package = pkgs.myEspanso;
    settings = ''
      extra_includes:
        - "../myespanso/default.yml"
    '';
  };
  home.file = {
    ".config/myespanso" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config";
    };
  };
}
