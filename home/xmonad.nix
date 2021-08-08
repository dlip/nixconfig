{ pkgs, ... }:
{
  xsession = {
    enable = true;

    # initExtra = extra + polybarOpts;

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
      ];
      config = ./files/xmonad.hs;
    };
  };
}
