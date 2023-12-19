{pkgs, ...}: {
  imports = [
    ./alacritty
    # ./emacs
    #./kitty
    #./leftwm
    # ./vscode
    # ./kde
    # ./awesome
    ./mpv
    #./sway
    #./waybar
    #./hyprland
    ./wezterm
  ];

  home.packages = with pkgs; [
    # antimicrox
    audacity
    dbeaver
    discord
    emoji-menu
    # cinnamon.nemo
    power-menu
    f3d
    feh
    # freecad
    # solvespace
    inkscape
    gimp
    # gnome.file-roller
    # google-chrome-dev
    gramps
    # ledger-live-desktop
    # lens
    # logseq
    mlt
    # mongodb-compass
    # neovide
    # nyxt
    # nheko # curl error
    # memento
    # obsidian
    openscad
    # plover.dev
    qalculate-gtk
    slack
    # spotify # cant get any songs to play
    # teams
    # vial
    xclip
    # xfce.thunar
    xorg.xmodmap
    # xournalpp
    # yubikey-manager-qt #broken
    # yubioath-desktop #broken
    # zathura # brokon on mac https://github.com/NixOS/nixpkgs/issues/274276
    # zoom-us # download error
  ];
}
