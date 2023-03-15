{ config, pkgs, lib, ... }:
{
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  security.pam.services.dane.enableKwallet = true;
}
