{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./syncthing
  ];

  home.packages = with pkgs.unstable; [
    acpi
    appimage-run
    binutils
    mimic
    evtest
    fusee-launcher
    iotop
    iputils
    kmonad
    krename
    nix-du
    python311Packages.adafruit-nrfutil
    qmk
    strace
    tiramisu
    traceroute
    usbutils
    ventoy
    xdotool
  ];
}
