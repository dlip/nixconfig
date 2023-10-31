{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./i3
    ./rofi
    ./talon
  ];

  home.packages = with pkgs.unstable; [
    anki
    alttab
    arandr
    brightnessctl
    blender
    calibre
    drawio
    easyeffects
    gnome.seahorse
    gparted
    firefox
    fstl
    keyd
    kdenlive
    krita
    kicad
    libreoffice
    obs-studio
    plexamp
    postman
    remote-touchpad
    screenkey
    sidequest
    super-slicer-latest
    tdesktop
    vlc
    warpd
    whatsapp-for-linux
    yacreader
  ];
}