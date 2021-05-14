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
    libreoffice
    plexamp
    slack
    spotify
    vscode
    xorg.xmodmap
    yubikey-manager-qt
    yubioath-desktop
  ];
}
