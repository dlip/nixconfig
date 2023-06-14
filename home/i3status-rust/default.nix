{
  pkgs,
  config,
  ...
}: {
  imports = [
    ../autorandr
  ];
  home.file = {
    "${config.xdg.configHome}/i3status-rust".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/i3status-rust/config";
  };
  home.packages = with pkgs.unstable; [
    i3status-rust
  ];
}
