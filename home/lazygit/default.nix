{
  config,
  pkgs,
  ...
}: {
  home.packages = [pkgs.unstable.lazygit];

  home.file =
    if pkgs.stdenv.isDarwin
    then {
      "${config.home.homeDirectory}/Library/Application Support/lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/lazygit/config.yml";
    }
    else {
      "${config.xdg.configHome}/lazygit/config.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/lazygit/config.yml";
    };
}
