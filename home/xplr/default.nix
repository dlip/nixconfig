{ pkgs, ... }: 
let
  xplrConfig = "${config.xdg.configHome}/xplr";
in
{
  home.file = {
    "${xplrConfig}" = {
      recursive = true;
      source = ./config;
    };
  };

  home.packages = with pkgs; [
    xplr
  ];
}
