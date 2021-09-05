{ pkgs, ... }:
{
  services.network-manager-applet.enable = true;
  xsession = {
    enable = true;
    windowManager.command = ''
        ${pkgs.leftwm}/bin/leftwm
      '';
  };

  services.stalonetray = {
    enable = true;
    config = {
      decorations = null;
      transparent = false;
      dockapp_mode = null;
      geometry = "6x1-400+4";
      max_geometry = "0x0";
      background = "#313846";
      kludges = "force_icons_size";
      grow_gravity = "NE";
      icon_gravity = "NE";
      icon_size = 21;
      sticky = true;
      # window_strut = null;
      window_type = "dock";
      window_layer = "bottom";
      # no_shrink = false;
      skip_taskbar = true;
    };
  };

  home.packages = with pkgs; [
    polybar
    feh
    alttab
    dmenu
    betterlockscreen
    picom
    xmobar
    lemonbar
    conky
  ];

}
