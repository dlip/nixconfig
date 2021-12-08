{ ... }:
{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    #  "${config.xdg.configHome}/starship.toml".text = ''
    #   [nix_shell]
    #   use_name = false
    # '';
  };
}
