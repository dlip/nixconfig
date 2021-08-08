{ pkgs, ... }:
{
  services.network-manager-applet.enable = true;
  xsession = {
    enable = true;

    initExtra = ''
      ${pkgs.alttab}/bin/alttab -w 1&
      ${pkgs.feh}/bin/feh --bg-fill --randomize ~/Pictures/*&
    '';

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      extraPackages = hp: [
        hp.dbus
        hp.monad-logger
        hp.xmonad-contrib
      ];
      config = ./xmonad-config/app/Main.hs;
    };
  };
}
