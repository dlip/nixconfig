{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    fontconfig
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    overpass
    source-han-code-jp
    source-serif-pro
  ];
}
