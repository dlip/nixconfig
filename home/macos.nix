{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs.unstable; [
    iterm2
  ];
}
