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
    kmonad
    krename
    nix-du
    # python311Packages.adafruit-nrfutil
    qmk
    strace
    tiramisu
    traceroute
    usbutils
    ventoy
    xdotool
  ];
}
