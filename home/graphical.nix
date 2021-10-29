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
    anki
    audacity
    # blender
    brave
    calibre
    # chromium
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
    # godot
    gramps
    kdenlive
    # krita
    koreader
    lens
    libreoffice
    mpv
    # nyxt
    obs-studio
    obsidian
    postman
    # plexamp # sha incorrect
    qalculate-gtk
    slack
    spotify
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
