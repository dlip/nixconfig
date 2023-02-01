{ pkgs, lib, ... }:
{
  imports = [
    ./config.nix
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };

  home.packages = with pkgs; [
    libsForQt5.bismuth
    rc2nix
    plasma-browser-integration
  ];
}
