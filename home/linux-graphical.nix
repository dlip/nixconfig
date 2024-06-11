{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./hyprland
    # ./awesome
    # ./i3
    ./rofi
    ./talon
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    anki
    alttab
    arandr
    brightnessctl
    blender
    calibre
    dbeaver-bin
    drawio
    easyeffects
    gparted
    firefox
    f3d
    fstl
    keyd
    kdenlive
    kooha
    krita
    kicad-unstable
    libreoffice
    obs-studio
    pulsemixer
    plexamp
    # postman not found error
    remote-touchpad
    screenkey
    # orca-slicer
    # super-slicer-latest
    prusa-slicer
    tdesktop
    vlc
    warpd
    whatsapp-for-linux
    yacreader
  ];
}
