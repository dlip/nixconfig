{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./default.nix
    ./syncthing
    ./desktop.nix
    ./linux-graphical.nix
    ./mime.nix
    ./btop
  ];

  home.packages = with pkgs; [
    acpi
    # appimage-run
    binutils
    # mimic
    evtest
    fusee-launcher
    iotop
    iputils
    kanata
    kmonad
    krename
    nix-du
    ns-usbloader
    pinentry
    # python311Packages.adafruit-nrfutil
    qmk
    strace
    tagainijisho
    tiramisu
    traceroute
    usbutils
    ventoy
    xdotool
    xorg.xhost # add root to xsession: xhost si:localuser:root
  ];
}
