{ pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./rofi.nix
    ./vscode.nix
    ./leftwm.nix
  ];

  home.packages = with pkgs; [
    alttab
    anki
    blender
    calibre
    chromium
    dbeaver
    discord
    drawio
    emoji-menu
    firefox
    gimp
    gnome.file-roller
    gnome.seahorse
    godot
    gwenview
    kdenlive
    krita
    lens
    libreoffice
    logseq
    mpv
    nyxt
    obs-studio
    obsidian
    plexamp
    qalculate-gtk
    slack
    spotify
    tdesktop
    via
    vial
    vlc
    xclip
    yubikey-manager-qt
    yubioath-desktop
    zathura
    zoom-us
  ];
}
