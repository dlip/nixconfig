{ pkgs, ... }:
{
  imports = [
    # ./alacritty
    ./kitty
    ./rofi
    ./vscode
    ./kde
    # ./awesome
    # ./sway
  ];

  home.packages = with pkgs; [
    # anki
    appimage-run
    antimicrox
    arandr
    alttab
    audacity
    # blender
    calibre
    cozy
    dbeaver
    discord
    drawio
    easyeffects
    emoji-menu
    cinnamon.nemo
    keyd
    power-menu
    firefox
    gimp
    gnome.file-roller
    gnome.seahorse
    # godot
    gramps
    kdenlive
    # krita
    # kicad
    # ledger-live-desktop
    lens
    libreoffice
    logseq
    mlt
    mongodb-compass
    mpv
    neovide
    # nyxt
    obs-studio
    obsidian
    postman
    plexamp
    # plover.dev
    qalculate-gtk
    remote-touchpad
    slack
    # spotify
    # talon
    tdesktop
    vial
    vlc
    warpd
    xclip
    # xfce.thunar
    xorg.xmodmap
    # xournalpp
    yacreader
    # yubikey-manager-qt #broken
    # yubioath-desktop #broken
    # zathura # broken
    zoom-us
  ];
}
