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
      config = ./xmonad-config/Main.hs;
    };
  };
  programs.xmobar = {
    enable = true;
    extraConfig = ''
      Config
        { font        = "xft:FiraCode Nerd Font Mono:size=13:bold:antialias=true:hinting=true"
        , borderColor = "#d0d0d0"
        , border      = FullB
        , borderWidth = 3
        , bgColor     = "#222"
        , fgColor     = "grey"
        , position    = TopSize C 99 30
        , commands    =
            [ Run Cpu ["-t", "cpu: <fc=#4eb4fa><bar> <total>%</fc>"] 10
            , Run Network "wlp0s20f3" ["-S", "True", "-t", "net: <fc=#4eb4fa><rx></fc>/<fc=#4eb4fa><tx></fc>"] 10
            , Run Memory ["-t","mem: <fc=#4eb4fa><usedbar> <usedratio>%</fc>"] 10
            , Run Date "<fc=#4eb4fa>%a %d %b %Y %H:%M:%S </fc>" "date" 10
            , Run StdinReader
            ]
        , sepChar     = "%"
        , alignSep    = "}{"
        , template    = "  %StdinReader% | %cpu% | %memory% | %wlp0s20f3%  }{ %date%  "
        }
    '';
  };
  services.screen-locker = {
    enable = true;
    inactiveInterval = 30;
    lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dim";
    xautolockExtraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };
  services.picom = {
    enable = true;
    activeOpacity = "1.0";
    inactiveOpacity = "0.8";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    shadowOpacity = "0.75";
  };
  services.stalonetray = {
    enable = true;
    config = {
      decorations = null;
      transparent = false;
      dockapp_mode = null;
      geometry = "6x1-330+5";
      max_geometry = "6x1-525-5";
      background = "#222";
      kludges = "force_icons_size";
      grow_gravity = "NE";
      icon_gravity = "NE";
      icon_size = 16;
      sticky = true;
      # window_strut = null;
      window_type = "dock";
      window_layer = "bottom";
      # no_shrink = false;
      skip_taskbar = true;
    };
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
  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome3.adwaita-icon-theme;
    };
  };
  services.udiskie = {
    enable = true;
    tray = "always";
  };
  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.dropbox.enable = true;
  services.flameshot.enable = true;
  home.packages = with pkgs; [
    feh
    xmobar
    alttab
    light
    scrot
    playerctl
    dmenu
  ];
}
