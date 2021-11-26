{ config, lib, pkgs, ... }:
{
  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray --wait";
    };
  };
}
