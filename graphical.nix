{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki
    blender
    dbeaver
    discord
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
