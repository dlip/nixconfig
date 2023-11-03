{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./default.nix
    ./yabai
    ./skhd
    ./desktop.nix
    ./graphical.nix
  ];

  home.packages = with pkgs.unstable; [
    iterm2
  ];
}
