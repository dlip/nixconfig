{ config, pkgs, lib, ... }:
{
  services.xserver = {
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce+awesome";
      autoLogin.enable = true;
      autoLogin.user = "dane";
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
        thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];
      };
    };
    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };
}
