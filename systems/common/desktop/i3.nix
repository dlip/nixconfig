{
  config,
  pkgs,
  callPackage,
  ...
}: {
  environment.pathsToLink = ["/libexec"]; # links /libexec from derivations to /run/current-system/sw
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      autoLogin.enable = true;
      autoLogin.user = "dane";
      # job.preStart = "sleep 2"; # Hack to ensure X is ready for autoLogin
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
      ];
    };
  };

  # i18n.inputMethod = {
  #   enabled = "ibus";
  #   ibus.engines = with pkgs.ibus-engines; [typing-booster anthy];
  # };

  # environment.sessionVariables = {
  #   GTK_IM_MODULE = "ibus";
  #   QT_IM_MODULE = "ibus";
  #   XMODIFIERS = "@im=ibus";
  # };

  environment.systemPackages = with pkgs; [gnome.file-roller];
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.upower.enable = true;
}
