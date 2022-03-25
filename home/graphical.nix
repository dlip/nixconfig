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
    antimicrox
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
    juliusSpeech
    kdenlive
    # krita
    # kicad broken due to https://github.com/NixOS/nixpkgs/issues/165444
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
