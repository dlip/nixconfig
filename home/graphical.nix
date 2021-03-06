{ pkgs, ... }:
{
  imports = [
    # ./alacritty
    ./kitty
    ./rofi
    ./vscode
    ./awesome
    # ./sway
  ];

  home.packages = with pkgs; [
    # anki
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
    ledger-live-desktop
    lens
    libreoffice
    logseq
    mongodb
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
    xclip
    # xfce.thunar
    xorg.xmodmap
    # xournalpp
    yacreader
    # yubikey-manager-qt #broken
    # yubioath-desktop #broken
    zathura
    zoom-us
  ];
}
