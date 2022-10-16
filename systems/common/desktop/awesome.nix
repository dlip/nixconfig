{ config, pkgs, lib, ... }:
{
  hardware.pulseaudio.enable = false;
  services.xserver = {
    displayManager = {
      lightdm.enable = true;
      defaultSession = "cinnamon";
      autoLogin.enable = true;
      job.preStart = "sleep 2"; # Hack to ensure X is ready for autoLogin
      autoLogin.user = "dane";
    };
    desktopManager = {
      cinnamon.enable = true;
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };

  programs.thunar.plugins = [ pkgs.xfce.thunar-archive-plugin ];
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
}
