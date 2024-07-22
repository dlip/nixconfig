{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.hyprland = {
    enable = true;
  };

  services.greetd = {
    enable = true;
    settings = rec {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --cmd ${pkgs.hyprland}/bin/Hyprland";
      };
    };
  };
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  environment.systemPackages = with pkgs; [
    file-roller
    adwaita-icon-theme # default gnome cursors
  ];
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images
  i18n.inputMethod.fcitx5.waylandFrontend = true;
}
