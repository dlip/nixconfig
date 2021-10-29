config:
{ pkgs, ... }: 
{
  imports = [
    ./alacritty.nix
    ./rofi.nix
    ./scripts.nix
    # ./vscode
    (import ./awesome config)
  ];

  home.packages = with pkgs; [
    alttab
    # anki /build/anki-2.1.15/tests/test_addons.py:83: DeprecationWarning: Please use assertEqual instead.
    audacity
    blender
    brave
    calibre
    chromium
    cozy
    dbeaver
    discord
    drawio
    emoji-menu
    power-menu
    firefox
    gimp
    gnome.file-roller
    gnome.seahorse
    godot
    gramps
    gwenview
    kdenlive
    krita
    koreader
    lens
    libreoffice
    mpv
    nyxt
    obs-studio
    obsidian
    # plexamp # sha incorrect
    qalculate-gtk
    slack
    spotify
    tdesktop
    via
    vial
    vlc
    xclip
    xfce.thunar
    yacreader
    yubikey-manager-qt
    yubioath-desktop
    zathura
    zoom-us
  ];
}
