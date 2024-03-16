{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./i3
    ./rofi
    ./talon
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    anki
    alttab
    arandr
    brightnessctl
    blender
    calibre
    drawio
    easyeffects
    gnome.seahorse
    gparted
    firefox
    f3d
    fstl
    keyd
    kdenlive
    krita
    # kicad # "Service '${name}.service' with 'Type=oneshot' cannot have 'Restart=always' or 'Restart=on-success'"
    libreoffice
    obs-studio
    plexamp
    # postman not found error
    remote-touchpad
    screenkey
    sidequest
    # orca-slicer
    stable.super-slicer # broken https://github.com/NixOS/nixpkgs/issues/294114
    tdesktop
    vlc
    warpd
    whatsapp-for-linux
    yacreader
  ];
}
