{ pkgs, config, ... }:
let
  nnnConfig = "${config.xdg.configHome}/nnn";
  plugins = builtins.listToAttrs (
    map
      (
        file: {
          name = "${nnnConfig}/plugins/${file}";
          value = {
            source = "${pkgs.nnn-git}/plugins/${file}";
          };
        }
      )
      (builtins.attrNames (builtins.readDir "${pkgs.nnn-git}/plugins"))
  );
in
{
  home.packages = [
    pkgs.nnn
  ];

  home.file = {
    "${config.home.homeDirectory}/bin/n" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/nnn/n";
    };
  } // plugins;
}
