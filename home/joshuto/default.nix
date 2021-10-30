{ pkgs, config, ... }:
let
  joshutoConfig = "${config.xdg.configHome}/joshuto";
in
{
  home.file = {
    "${joshutoConfig}" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/joshuto/config";
    };
  };
}
