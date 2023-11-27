{
  pkgs,
  config,
  ...
}: {
  home.file = {
    "${config.xdg.configHome}/autorandr".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/autorandr/config";
  };

  home.packages = with pkgs; [
    autorandr
  ];

  services.autorandr = {
    enable = true;
  };
}
