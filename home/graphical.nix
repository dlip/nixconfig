{ pkgs, ... }:
{
  imports = [
    ./alacritty
    ./kitty
    ./rofi
    # ./vscode
    ./awesome
  ];

  home.packages = with pkgs; [
    anki
    antimicrox
    arandr
    alttab
    audacity
    # blender
    brave
    calibre
    chromium
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
    kicad
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
    plover.dev
    qalculate-gtk
    remote-touchpad
    slack
    # spotify
    talon
    tdesktop
    vial
    vlc
    xclip
    # xfce.thunar
    xournalpp
    yacreader
    # yubikey-manager-qt #broken
    # yubioath-desktop #broken
    zathura
    zoom-us
  ];
}
