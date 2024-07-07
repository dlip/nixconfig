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
    ./mpv
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
    gramps
    firefox
    f3d
    fstl
    helvum
    keyd
    kdenlive
    kooha
    krita
    kicad-unstable
    libreoffice
    obs-studio # sudo modprobe v4l2loopback devices=1 video_nr=21 card_label="OBS Cam" exclusive_caps=1
    v4l-utils
    # plover.dev
    pulsemixer
    # plexamp
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
