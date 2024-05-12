{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ../waybar
    ../swaync
  ];

  home.file =
    {
      "${config.xdg.configHome}/hypr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/config";
      # "${config.home.homeDirectory}/.local/share/icons/hyprcursor-catppuccin".source = "${pkgs.hyprcursor-catppuccin}";
    }
    // (pkgs.lib.attrsets.mapAttrs' (
      folder: type:
        pkgs.lib.attrsets.nameValuePair "${config.home.homeDirectory}/.local/share/icons/${folder}"
        {source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/hyprland/icons/${folder}";}
    ) (builtins.readDir ./icons));

  home.packages = with pkgs; [
    brightnessctl
    cliphist
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
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
    networkmanagerapplet
    rofimoji
  ];
}
