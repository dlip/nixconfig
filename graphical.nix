{ pkgs, ... }: {
  home.packages = with pkgs; [
    dbeaver
    firefox
    godot
    google-chrome
    plexamp
    slack
    spotify
  ];
}
