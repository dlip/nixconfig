{ pkgs, lib, ... }:
{
  imports = [
    ./config.nix
  ];

  i18n.inputMethod = {
    type = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };


  home.packages = with pkgs; [
    libsForQt5.bismuth
    libsForQt5.konqueror
    libsForQt5.kwallet
    rc2nix
    plasma-browser-integration
  ];
}
