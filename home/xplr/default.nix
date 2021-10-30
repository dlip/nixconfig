{ pkgs, config, ... }:
let
  xplrConfig = "${config.xdg.configHome}/xplr";
  symlinkedFiles = builtins.listToAttrs (
    map
      (
        file: {
          name = "${xplrConfig}/${file}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/xplr/config/${file}";
          };
        }
      )
      (builtins.attrNames (builtins.readDir ./config))
  );
in
{
  home.file = symlinkedFiles // {
    "${xplrConfig}/plugins/comex" = {
      source = pkgs.xplr-plugins.comex;
    };
    "${xplrConfig}/plugins/command-mode" = {
      source = pkgs.xplr-plugins.command-mode;
    };
  };

  home.packages = with pkgs; [
    xplr
  ];
}
