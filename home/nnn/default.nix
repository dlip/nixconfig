{ pkgs, config, nnn, ... }:
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

  n = pkgs.writeShellScriptBin "n" ''
    export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;t:nmount;v:imgview;r:renamer'

    BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
    export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

    ${pkgs.nnn}/bin/nnn "$@"
  '';
in
{
  home.packages = [ n ];
  home.file = plugins;
}
