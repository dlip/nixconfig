{ pkgs, ... }:
let
  myscripts = {
    launch-default-programs = pkgs.writeShellScriptBin "launch-default-programs" ''
      firefox&
      alacritty&
      slack&
      spotify&
    '';

    update-wallpaper = pkgs.writeShellScriptBin "update-wallpaper" ''
      nice -19 ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/wallpapers --fx dim --dim 50
      ${pkgs.betterlockscreen}/bin/betterlockscreen -w dim
    '';

    lock-screen = pkgs.writeShellScriptBin "lock-screen" ''
      ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim
    '';

    ssuspend = pkgs.writeShellScriptBin "ssuspend" ''
      systemctl suspend
    '';
  };
in
{
  home.packages = builtins.attrValues myscripts;
}
