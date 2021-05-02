{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki
    blender
    dbeaver
    discord
    firefox
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
  ];
}
