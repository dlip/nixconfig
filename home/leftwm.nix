{ pkgs, ... }:
{
  services.network-manager-applet.enable = true;
  xsession = {
    enable = true;
    windowManager.command = ''
        ${pkgs.leftwm}/bin/leftwm
      '';
  };

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.gnome3.adwaita-icon-theme;
      size = "16x16";
    };
    settings = {
      global = {
        monitor = 0;
        geometry = "600x50-50+65";
        shrink = "yes";
        transparency = 10;
        padding = 16;
        horizontal_padding = 16;
        font = "FiraCode Nerd Font 10";
        line_height = 4;
        format = ''<b>%s</b>\n%b'';
      };
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
    dunst
    leftwm
  ];

}
