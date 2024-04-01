{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../waybar
    ../swaylock
  ];

  home.file =
    {
      "${config.xdg.configHome}/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/config";
    }
    // (pkgs.lib.attrsets.mapAttrs' (
      folder: type:
        pkgs.lib.attrsets.nameValuePair "${config.home.homeDirectory}/.local/share/icons/${folder}"
        {source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/icons/${folder}";}
    ) (builtins.readDir ./icons));

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    fuzzel
    grimblast
    hypridle
    hyprlock
    hyprpaper
    libnotify
    playerctl
    sway-contrib.grimshot
    swayidle
    udiskie
  ];
}
