{
  config,
  pkgs,
  ...
}: {
  home.file = {
    "${config.xdg.configHome}/dunst/dunstrc".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/dunst/config";
  };

  systemd.user.services.dunst = {
    Unit = {
      Description = "Dunst notification daemon";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      # ExecCondition = ''sh -c '[ -n "$WAYLAND_DISPLAY" ]'';
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };
}
