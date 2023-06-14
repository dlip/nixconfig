{
  pkgs,
  config,
  ...
}: {
  services.espanso = {
    enable = true;
    package = pkgs.unstable.espanso;
  };

  # home.file = {
  #   "${config.xdg.configHome}/espanso".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/espanso/config";
  # };
}
