{pkgs, ...}: {
  home.packages = with pkgs; [
    # minecraft
    bottles
    heroic
    lutris
    mangohud
    gamemode
    protontricks
    protonup
    vulkan-tools
    # wine
    wine64
    winetricks
  ];
}
