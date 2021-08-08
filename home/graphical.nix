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
    slack
    spotify
    vlc
    xclip
    xorg.xmodmap
    yubikey-manager-qt
    yubioath-desktop
    zoom-us
  ];
}
