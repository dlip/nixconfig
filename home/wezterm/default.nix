{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [wezterm];
  home.file = {
    "${config.xdg.configHome}/wezterm/wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/wezterm/wezterm.lua";
  };
}
