{ pkgs, ... }: {
  imports = [
    ./vscode.nix
  ];
  
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
    mpv
    gwenview
    slack
    spotify
    xorg.xmodmap
    xclip
    yubikey-manager-qt
    yubioath-desktop
    zoom-us
  ];
}
