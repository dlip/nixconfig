{
  pkgs,
  config,
  ...
}: let
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
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc];
  };
  xsession = {
    enable = true;
    profileExtra = builtins.readFile ../files/xprofile;

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        # luadbi-mysql # Database abstraction layer
      ];
    };
  };

  home.file =
    symlinkedFiles
    // {
      "${awesomeHome}/env.lua".text = ''
        arc_icon_theme = "${pkgs.repo-arc-icon-theme}"
      '';
      "${awesomeHome}/awesome-wm-widgets".source = pkgs.repo-awesome-wm-widgets;
      "${awesomeHome}/json.lua".source = "${pkgs.repo-json-lua}/json.lua";
    };

  home.packages = with pkgs; [
    feh
    alttab
    light
    scrot
    playerctl
    pamixer
    sox
    brightnessctl
    notify-desktop
    i3lock-color
    xorg.xkill
  ];

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

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.flameshot.enable = true;
  services.volnoti.enable = true;
  services.poweralertd.enable = true;
  services.udiskie = {
    enable = true;
    tray = "always";
  };

  services.picom = {
    enable = false;
    backend = "glx";
    vSync = true;
  };
}
