{ pkgs, ... }:
let
  launch-default-programs = pkgs.writeShellScriptBin "launch-default-programs" ''
    firefox&
    code&
    slack&
    spotify&
  '';

  update-wallpaper = pkgs.writeShellScriptBin "update-wallpaper" ''
    nice -19 ${pkgs.betterlockscreen}/bin/betterlockscreen -u ~/wallpapers --fx dim
    ${pkgs.betterlockscreen}/bin/betterlockscreen -w dim
  '';

  lock-screen = pkgs.writeShellScriptBin "lock-screen" ''
    ${pkgs.betterlockscreen}/bin/betterlockscreen -l dim
  '';

  ssuspend = pkgs.writeShellScriptBin "ssuspend" ''
    systemctl suspend
  '';

in
{
  services.network-manager-applet.enable = true;
  xsession = {
    enable = true;

    initExtra = ''
      ${pkgs.alttab}/bin/alttab -w 1&
      ${pkgs.betterlockscreen}/bin/betterlockscreen -w dim&
      ${update-wallpaper}/bin/update-wallpaper&
      ibus-daemon&
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
        , additionalFonts = [ "xft:FiraCode Nerd Font Mono:size=24:normal:antialias=true:hinting=true" ]
        , borderColor = "#4eb4fa"
        , border      = BottomB
        , borderWidth = 2
        , bgColor     = "#313846"
        , fgColor     = "#d0d0d0"
        , position    = TopSize C 100 30
        , commands    =
            [ Run Cpu ["-t", "<fn=1></fn> <fc=#4eb4fa><total>%</fc>"] 10
            , Run Network "wlp0s20f3" ["-S", "True", "-t", "<fn=1></fn> <fc=#4eb4fa><rx></fc> <fn=1></fn> <fc=#4eb4fa><tx></fc>"] 10
            , Run Memory ["-t","<fn=1></fn> <fc=#4eb4fa><usedratio>%</fc>"] 10
            , Run Date "<fc=#4eb4fa>%a %d %b %Y %H:%M:%S </fc>" "date" 10
            , Run StdinReader
            -- battery monitor
            , Run Battery        [ "--template" , "batt: <acstatus>"
                                 , "--Low"      , "10"        -- units: %
                                 , "--High"     , "80"        -- units: %
                                 , "--low"      , "darkred"
                                 , "--normal"   , "darkorange"
                                 , "--high"     , "darkgreen"

                                 , "--" -- battery specific options
                                           -- discharging status
                                           , "-o"  , "<left>% (<timeleft>)"
                                           -- AC "on" status
                                           , "-O"  , "<fc=#dAA520>Charging</fc>"
                                           -- charged status
                                           , "-i"  , "<fc=#006000>Charged</fc>"
                                 ] 50
            ]
        , sepChar     = "%"
        , alignSep    = "}{"
        , template    = " <fn=1></fn> %StdinReader% %cpu% %memory% %wlp0s20f3% %battery% }{ %date% <fn=1></fn> "
        }
    '';
  };

  services.screen-locker = {
    enable = true;
    inactiveInterval = 5;
    lockCmd = "${lock-screen}/bin/lock-screen";
    xautolockExtraOptions = [
      "Xautolock.killer: systemctl suspend"
    ];
  };

  # services.picom = {
  #   enable = true;
  #   activeOpacity = "1.0";
  #   inactiveOpacity = "0.8";
  #   backend = "glx";
  #   fade = true;
  #   fadeDelta = 5;
  #   opacityRule = [ "100:name *= 'i3lock'" ];
  #   shadow = true;
  #   shadowOpacity = "0.75";
  #   vSync = true;
  # };

  services.stalonetray = {
    enable = true;
    config = {
      decorations = null;
      transparent = false;
      dockapp_mode = null;
      geometry = "6x1-330+4";
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
    launch-default-programs
    update-wallpaper
    lock-screen
    feh
    xmobar
    alttab
    light
    scrot
    playerctl
    dmenu
    betterlockscreen
    brightnessctl
    networkmanager_dmenu
    ssuspend
  ];
}
