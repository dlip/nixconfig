{
  config,
  pkgs,
  ...
}: {
  home.file."${config.xdg.configHome}/leftwm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/leftwm/config";
  home.file."${config.xdg.configHome}/eww".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/leftwm/config/themes/basic_eww/eww-bar";

  home.packages = with pkgs.unstable; [
    eww
    polybar
    feh
    dmenu
    pamixer
    playerctl
    brightnessctl
  ];

  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.flameshot.enable = true;
  services.volnoti.enable = true;
  services.udiskie = {
    enable = true;
    tray = "always";
  };

  # services.stalonetray = {
  #   enable = true;
  #   config = {
  #     decorations = null;
  #     transparent = false;
  #     dockapp_mode = null;
  #     geometry = "6x1-510+10";
  #     max_geometry = "0x0";
  #     background = "#313846";
  #     kludges = "force_icons_size";
  #     grow_gravity = "NE";
  #     icon_gravity = "NE";
  #     icon_size = 21;
  #     slot_size = 30;
  #     sticky = true;
  #     # window_strut = null;
  #     window_type = "dock";
  #     window_layer = "top";
  #     # no_shrink = false;
  #     skip_taskbar = true;
  #   };
  # };
}
