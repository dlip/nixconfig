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
    blender
    chromium
    dbeaver
    discord
    drawio
    emoji-menu
    firefox
    gimp
    gnome.file-roller
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
    gnome.seahorse
    slack
    spotify
    tdesktop
    via
    vial
    vlc
    xclip
    yubikey-manager-qt
    yubioath-desktop
    zoom-us
  ];
}
