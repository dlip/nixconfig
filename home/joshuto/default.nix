{ pkgs, config, ... }:
let
  joshutoConfig = "${config.xdg.configHome}/joshuto";
in
{
  home.file = {
    "${joshutoConfig}" = {
      recursive = true;
      source = ./config;
    };
  };
}
