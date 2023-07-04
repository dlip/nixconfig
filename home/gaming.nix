{pkgs, ...}: {
  home.packages = with pkgs; [
    # minecraft
    # lutris
    mangohud
    gamemode
    protontricks
    vulkan-tools
  ];
}
