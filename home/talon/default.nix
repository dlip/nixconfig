{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.talon];

  home.file = {
    "${config.home.homeDirectory}/.talon/user".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/talon/config";
  };
}
