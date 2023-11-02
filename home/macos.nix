{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./yabai
    ./skhd
  ];

  home.packages = with pkgs.unstable; [
    iterm2
  ];
}
