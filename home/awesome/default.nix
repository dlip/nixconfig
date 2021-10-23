{ pkgs, ... }:
{
  xsession = {
    enable = true;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };
  };

  home.file.".config/awesome/rc.lua".source = ./rc.lua;
  home.packages = with pkgs; [
    feh
    alttab
    light
    scrot
    playerctl
    pamixer
    sox
    betterlockscreen
    brightnessctl
    notify-desktop
  ];
  
  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "lock-screen";
    xautolock.extraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.dropbox.enable = true;
  services.flameshot.enable = true;
  services.volnoti.enable = true;

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    extraOptions = ''
      use-ewmh-active-win = true;
    '';
  };
}
