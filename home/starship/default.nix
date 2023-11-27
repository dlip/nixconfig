{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableZshIntegration = true;
  };

  home.file."${config.xdg.configHome}/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/starship/starship.toml";
}
