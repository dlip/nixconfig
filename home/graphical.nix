{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki
    blender
    dbeaver
    discord
    firefox-devedition-bin
    gimp
    godot
    google-chrome
    krita
    lens
    libreoffice
    plexamp
    slack
    spotify
    vscode
    xorg.xmodmap
    xclip
    yubikey-manager-qt
    yubioath-desktop
    zoom-us
  ];
}
