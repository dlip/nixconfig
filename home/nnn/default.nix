{
  pkgs,
  config,
  nnn,
  ...
}: let
  nnnConfig = "${config.xdg.configHome}/nnn";
  plugins = builtins.listToAttrs (
    map
    (
      file: {
        name = "${nnnConfig}/plugins/${file}";
        value = {
          source = "${pkgs.repo-nnn}/plugins/${file}";
        };
      }
    )
    (builtins.attrNames (builtins.readDir "${pkgs.repo-nnn}/plugins"))
  );

  nnn = pkgs.writeShellScriptBin "nnn" ''
    export NNN_PLUG='f:finder;o:fzopen;p:mocplay;d:diffs;m:nmount;v:imgview;r:renamer;c:.cbcp;s:-!echo $PWD/$nnn|xclip -sel c*;h:-!hx $nnn*;t:-!~/code/nixconfig/scripts/helix-open $PWD/$nnn*'

    BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
    export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

    ${pkgs.nnn}/bin/nnn "$@"
  '';
in {
  home.packages = [nnn];
  home.file = plugins;
}
