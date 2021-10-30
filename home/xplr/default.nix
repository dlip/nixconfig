{ pkgs, config, ... }: 
let
  xplrConfig = "${config.xdg.configHome}/xplr";
in
{
  home.file = {
    "${xplrConfig}" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/xplr/config";
    };
  };

  home.packages = with pkgs; [
    xplr
  ];
}
