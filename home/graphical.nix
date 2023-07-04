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
  ];

  home.packages = with pkgs.unstable; [
    anki
    appimage-run
    # antimicrox
    arandr
    alttab
    audacity
    brightnessctl
    # blender
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
    feh
    firefox
    gimp
    # gnome.file-roller
    gnome.seahorse
    gramps
    kdenlive
    krita
    # kicad
    # ledger-live-desktop
    lens
    # libreoffice
    # logseq
    mlt
    # mongodb-compass
    # neovide
    # nyxt
    # nheko # curl error
    memento
    obs-studio
    obsidian
    postman
    plexamp
    # plover.dev
    qalculate-gtk
    remote-touchpad
    screenkey
    slack
    # spotify # cant get any songs to play
    # talon
    tdesktop
    vial
    vlc
    warpd
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
