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
        , additionalFonts = [ "xft:FontAwesome:pixelsize=14:antialias=true:hinting=true",
                              "xft:FiraCode Nerd Font Mono:size=24:normal:antialias=true:hinting=true" ]
        , borderColor = "#4eb4fa"
        , border      = BottomB
        , borderWidth = 2
        , bgColor     = "#313846"
        , fgColor     = "#d0d0d0"
        , position    = TopSize C 100 30
        , commands    =
            [ Run Cpu ["-t", "<fn=2></fn> <fc=#4eb4fa><total>%</fc>"
              , "-L", "80"
              , "-H", "90"
              , "-n", "#e4b63c"
              , "-h", "#fa4e4e"
            ] 10
            , Run DynNetwork
              [ "-S", "True"
              , "-L", "3145728"
              , "-H", "6291456"
              , "-n", "#e4b63c"
              , "-h", "#fa4e4e"
              , "-t", "<fn=2></fn> <fc=#4eb4fa><rx></fc> <fn=2></fn> <fc=#4eb4fa><tx></fc>"
              ] 10
            , Run Memory
              [ "-t","<fn=2></fn> <fc=#4eb4fa><usedratio>%</fc>"
              , "-L", "80"
              , "-H", "90"
              , "-n", "#e4b63c"
              , "-h", "#fa4e4e"
              ] 10
            , Run Date "<fc=#4eb4fa>%a %d %b %Y %H:%M:%S </fc>" "date" 10
            , Run StdinReader
            , Run Battery
              [ "-t", "<fc=#d0d0d0><acstatus></fc>"
              , "-L", "20"
              , "-H", "85"
              , "-l", "#fa4e4e"
              , "-n", "#e4b63c"
              , "-h", "#7cac7a"
              , "--" -- battery specific options
              -- discharging status
              , "-o"  , "<fn=1>\xf242</fn> <left>% <fc=#d0d0d0>(<timeleft>)</fc>"
              -- AC "on" status
              , "-O"  , "<fn=1>\xf1e6</fn> <left>%"
              -- charged status
              , "-i"  , "<fn=1>\xf1e6</fn> <left>%"
              , "--off-icon-pattern", "<fn=1>\xf1e6</fn>"
              , "--on-icon-pattern", "<fn=1>\xf1e6</fn>"
              ] 10
            --- https://www.icao.int/safety/iStars/Pages/Weather-Conditions.aspx
            , Run WeatherX "YSSY"
              [ ("", "")
               , ("clear", "")
               , ("sunny", "")
               , ("mostly clear", "")
               , ("mostly sunny", "")
               , ("partly sunny", "")
               , ("fair", "")
               , ("cloudy","")
               , ("overcast","")
               , ("partly cloudy", "杖")
               , ("mostly cloudy", "")
               , ("considerable cloudiness", "")]
              [ "-t", "<fn=2><skyConditionS></fn> <tempC>°"
              , "-L", "10"
              , "-H", "20"
              , "-l", "#d0d0d0"
              , "-n", "#d0d0d0"
              , "-h", "#d0d0d0"
              ] 36000
            , Run DiskIO [("/", "<fc=#4eb4fa><total>/s</fc>")] [ ] 10
            , Run DiskU
              [("/", "<fc=#4eb4fa><used>/<size></fc>")]
              [ "-L", "80"
              , "-H", "90"
              , "-m", "1"
              , "-p", "3"
              , "-n", "#e4b63c"
              , "-h", "#fa4e4e"
              ] 20
            ]
        , sepChar     = "%"
        , alignSep    = "}{"
        , template    = " <fn=2></fn> %StdinReader% %cpu% %memory% <fn=2></fn> %disku% %diskio% %dynnetwork% %battery% }{ %date% %YSSY%<fn=2></fn> "
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

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
    extraOptions = ''
      use-ewmh-active-win = true;
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
  services.network-manager-applet.enable = true;
  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.dropbox.enable = true;
  services.flameshot.enable = true;

  home.packages = with pkgs; [
    launch-default-programs
    update-wallpaper
    lock-screen
    ssuspend

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
    notify-desktop
  ];
}
