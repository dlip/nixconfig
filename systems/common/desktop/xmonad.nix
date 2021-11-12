{ config, pkgs, lib, ... }:
{
  services.xserver.windowManager.xmonad = {
    displayManager = {
      defaultSession = lib.mkDefault "none+xmonad";
    };

    enable = true;
    enableContribAndExtras = true;
  };
}
