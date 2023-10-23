{pkgs, ...}: {
  imports = [
    ./alacritty
    #./kitty
    ./rofi
    #./leftwm
    # ./vscode
    # ./kde
    # ./awesome
    ./mpv
    ./sway
    ./waybar
    ./hyprland
    ./i3
    ./talon
  ];

  home.packages = with pkgs.unstable; [
    anki
    appimage-run
    # antimicrox
    arandr
    alttab
    audacity
    brightnessctl
    blender
    calibre
    cozy
    dbeaver
    discord
    drawio
    easyeffects
    emoji-menu
    # cinnamon.nemo
    keyd
    power-menu
    f3d
    fstl
    feh
    firefox
    # freecad
    # solvespace
    inkscape
    gimp
    # gnome.file-roller
    gnome.seahorse
    # google-chrome-dev
    gparted
    gramps
    kdenlive
    krita
    kicad
    kisslicer
    # ledger-live-desktop
    # lens
    libreoffice
    # logseq
    mlt
    # mongodb-compass
    # neovide
    # nyxt
    # nheko # curl error
    # memento
    obs-studio
    obsidian
    openscad
    postman
    plexamp
    # plover.dev
    qalculate-gtk
    remote-touchpad
    screenkey
    sidequest
    slack
    # spotify # cant get any songs to play
    super-slicer-latest
    # teams
    tdesktop
    # vial
    vlc
    warpd
    whatsapp-for-linux
    xclip
    # xfce.thunar
    xorg.xmodmap
    # xournalpp
    yacreader
    # yubikey-manager-qt #broken
    # yubioath-desktop #broken
    zathura
    # zoom-us # download error
  ];
}
