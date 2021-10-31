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
  home.file = symlinkedFiles // builtins.listToAttrs (map
    (plugin: {
      name = "${xplrConfig}/plugins/${plugin}";
      value = {
        source = (builtins.getAttr plugin pkgs.xplrPlugins);
      };
    })
    (builtins.attrNames pkgs.xplrPlugins));

  home.packages = with pkgs; [
    xplr
  ];
}
