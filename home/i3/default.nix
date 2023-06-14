{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../autorandr
  ];
  home.file = {
    "${config.xdg.configHome}/i3/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/i3/config";
  };
  home.packages = with pkgs.unstable; [
    i3lock-color
    playerctl
    brightnessctl
    paperview
    xwinwrap
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc];
  };

  services.screen-locker = {
    enable = true;
    xautolock.enable = false;
    lockCmd = ''${pkgs.i3lock-color}/bin/i3lock-color -i ${config.home.homeDirectory}/sync/wallpapers/i3lock.png --ring-color=5e81ac --inside-color=2e3440 --ringver-color=88c0d0 --insidever-color=5e81ac --ringwrong-color=b74242 --insidewrong-color=c62c2c --line-color=20242c --keyhl-color=88c0d0 --wrong-text="nope" --ring-width=20'';
  };

  services.xidlehook = {
    enable = true;
    not-when-fullscreen = true;
    not-when-audio = true;
    timers = [
      {
        delay = 290;
        command = ''${pkgs.libnotify}/bin/notify-send "Idle" "Locking screen in 10 seconds..."'';
        canceller = ''${pkgs.libnotify}/bin/notify-send "Idle" "Oh you're awake, my appologies sir."'';
      }
      {
        delay = 300;
        command = ''${pkgs.i3lock-color}/bin/i3lock-color -i ${config.home.homeDirectory}/sync/wallpapers/i3lock.png --ring-color=5e81ac --inside-color=2e3440 --ringver-color=88c0d0 --insidever-color=5e81ac --ringwrong-color=b74242 --insidewrong-color=c62c2c --line-color=20242c --keyhl-color=88c0d0 --wrong-text="nope" --ring-width=20'';
      }
    ];
  };

  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
  };

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.flameshot.enable = true;
  services.volnoti.enable = true;
  services.udiskie = {
    enable = true;
    tray = "always";
  };
}
