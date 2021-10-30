{ xrandrCommand ? "" }:
{ pkgs, config, ... }:
let
  awesomeHome = "${config.xdg.configHome}/awesome";
    symlinkedFiles = builtins.listToAttrs (
    map
      (
        file: {
          name = "${awesomeHome}/${file}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/awesome/config/${file}";
          };
        }
      )
      (builtins.attrNames (builtins.readDir ./config))
  );
in {
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

  home.file = symlinkedFiles // {
    "${awesomeHome}/env.lua".text = ''
      xrandr_command = "${xrandrCommand}"
    '';
  };
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
    i3lock
  ];

  services.betterlockscreen = {
    enable = true;
    arguments = [
      "-l dim"
    ];
    inactiveInterval = 60;
  };

  systemd.user.services.ibus = {
    Unit = {
      Description = "IBus Daemon";
      Requires = [ "tray.target" ];
      After = [ "graphical-session-pre.target" "tray.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install = { WantedBy = [ "graphical-session.target" ]; };
    Service = { ExecStart = "${pkgs.ibus}/bin/ibus-daemon"; };
  };

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
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
