{
  pkgs,
  config,
  ...
}: {
  programs.nushell = {
    enable = true;
    extraConfig = ''
      source "${pkgs.nu_scripts}/share/nu_scripts/aliases/git/git-aliases.nu"
      source "${pkgs.nu_scripts}/share/nu_scripts/custom-completions/git/git-completions.nu"
      source "${pkgs.nu_scripts}/share/nu_scripts/modules/nix/nix.nu"
      plugin add "${pkgs.nushellPlugins.gstat}/bin/nu_plugin_gstat"
      source ~/code/nixconfig/home/nushell/custom.nu
    '';
    extraEnv = ''
      use "${pkgs.nu_scripts}/share/nu_scripts/themes/nu-themes/catppuccin-mocha.nu"
      $env.config = {
        show_banner: false,
        color_config: (catppuccin-mocha),
        hooks: {
          pre_prompt: [(source ${pkgs.nu_scripts}/share/nu_scripts/nu-hooks/nu-hooks/direnv/config.nu)]
        }
      }
    '';
  };
}
