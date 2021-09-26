{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./rofi.nix
    ./vscode.nix
    ./xmonad.nix
  ];

  home.packages = with pkgs; [
    alttab
    anki
    audacity
    blender
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
