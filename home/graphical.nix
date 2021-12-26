{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./rofi
    # ./vscode
    ./awesome
  ];

  home.packages = with pkgs; [
    arandr
    alttab
    audacity
    # blender
    brave
    calibre
    # chromium
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
    koreader
    ledger-live-desktop
    lens
    libreoffice
    mpv
    neovide
    # nyxt
    obs-studio
    obsidian
    postman
    plexamp
    qalculate-gtk
    slack
    # spotify
    tdesktop
    vial
    vlc
    xclip
    # xfce.thunar
    yacreader
    yubikey-manager-qt
    yubioath-desktop
    zathura
    zoom-us
  ];
}
