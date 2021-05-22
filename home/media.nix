{ pkgs, ... }: {
  home.packages = with pkgs; [
    kodi
    spotify
  ];
}
