{ pkgs, config, ... }:
let
  myscripts = {
    launch-default-programs = pkgs.writeShellScriptBin "launch-default-programs" ''
      brave&
      alacritty&
      slack&
      spotify&
    '';

    update-wallpaper = pkgs.writeShellScriptBin "update-wallpaper" ''
      nice -19 ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/wallpapers --fx dim --dim 20
      ${pkgs.betterlockscreen}/bin/betterlockscreen -w dim
    '';

    lock-screen = pkgs.writeShellScriptBin "lock-screen" ''
      ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim
    '';

    ssuspend = pkgs.writeShellScriptBin "ssuspend" ''
      systemctl suspend
    '';
  };
  # symlinkedFiles = builtins.listToAttrs (
  #   map
  #     (
  #       file: {
  #         name = "${config.home.homeDirectory}/bin/${file}";
  #         value = {
  #           source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/scripts/${file}";
  #         };
  #       }
  #     )
  #     (builtins.attrNames (builtins.readDir ./scripts))
  # );
in
{
  home.packages = builtins.attrValues myscripts;
  # home.file = symlinkedFiles;
}
