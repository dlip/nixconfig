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
    kanata
    kmonad
    krename
    nix-du
    ns-usbloader
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
