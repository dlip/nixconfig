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
in
{
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc ];
  };
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

  services.blueman-applet.enable = true;
  services.pasystray.enable = true;
  services.clipmenu.enable = true;
  services.flameshot.enable = true;
  services.volnoti.enable = true;
  services.udiskie = {
    enable = true;
    tray = "always";
  };

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
  };
}
