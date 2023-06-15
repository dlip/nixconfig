{
  pkgs,
  config,
  ...
}: {
  systemd.user.services.espanso = {
    Unit = {Description = "Espanso: cross platform text expander in Rust";};
    Service = {
      Type = "exec";
      ExecStart = "${pkgs.unstable.espanso}/bin/espanso daemon";
      Restart = "on-failure";
    };
    Install = {WantedBy = ["default.target"];};
  };

  home.file."${config.xdg.configHome}/espanso".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config";
}
