{ pkgs, ... }: {
  imports = [
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    anki
    blender
    dbeaver
    discord
    drawio
    firefox-devedition-bin
    gimp
    godot
    google-chrome
    krita
    lens
    libreoffice
    logseq
    nyxt
    obs-studio
    obsidian
    plexamp
    mpv
    gwenview
    slack
    spotify
    xorg.xmodmap
    xclip
    vlc
    kdenlive
    yubikey-manager-qt
    yubioath-desktop
    zoom-us
  ];
}
