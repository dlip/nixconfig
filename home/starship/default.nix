{ config, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  home.file."${config.xdg.configHome}/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/starship/starship.toml";
}
