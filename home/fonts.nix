{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    emacs-all-the-icons-fonts
    font-awesome
    fontconfig
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "RobotoMono" "SourceCodePro" ]; })
  ];
}
