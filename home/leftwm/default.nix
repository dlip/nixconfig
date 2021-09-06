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
    windowManager.command = ''
        ${pkgs.leftwm}/bin/leftwm
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


  home.file = {
    ".config/leftwm/config.toml".source = ./config.toml;
    ".config/leftwm/themes/current".source = ./themes/xmobar;
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
    kitty
    stalonetray
  ];

}
