{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fontconfig
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    overpass
    source-han-code-jp
    source-serif-pro
  ];
}
