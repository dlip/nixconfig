{
  pkgs,
  config,
  ...
}: {
  programs.nushell = {
    enable = true;
    extraConfig = ''
      source "${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu"
      register "${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat"
      source ~/code/nixconfig/home/nushell/custom.nu
    '';
  };
}
