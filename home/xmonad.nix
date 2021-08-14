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
      Config { font = "-*-Fixed-Bold-R-Normal-*-13-*-*-*-*-*-*-*"
             , bgColor = "black"
             , fgColor = "grey"
             , position = TopW L 90
             , lowerOnStart = True
             , commands = [ Run Weather "EGPF" ["-t"," <tempF>F","-L","64","-H","77","--normal","green","--high","red","--low","lightblue"] 36000
                          , Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10
                          , Run Memory ["-t","Mem: <usedratio>%"] 10
                          , Run Swap [] 10
                          , Run Date "%a %b %_d %l:%M" "date" 10
                          , Run StdinReader
                          ]
             , sepChar = "%"
             , alignSep = "}{"
             , template = "%StdinReader% }{ %cpu% | %memory% * %swap%    <fc=#ee9a00>%date%</fc> | %EGPF%"
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

  services.stalonetray = {
    enable = true;
    config = {
      geometry = "3x1-600+0";
      decorations = null;
      icon_size = 30;
      sticky = true;
      background = "#cccccc";
    };
  };

  home.packages = with pkgs; [
    feh
    xmobar
    alttab
  ];
}
