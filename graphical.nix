{ pkgs, ... }: {
  home.packages = with pkgs; [
    dbeaver
    discord
    firefox
    godot
    google-chrome
    plexamp
    slack
    spotify
  ];
}
