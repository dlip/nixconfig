{ pkgs, lib, ... }:
{
  imports = [
    ./config.nix
  ];

  home.packages = with pkgs; [
    libsForQt5.bismuth
    rc2nix
    plasma-browser-integration
  ];
}
