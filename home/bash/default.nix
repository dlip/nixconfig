{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.bash = {
    enable = true;
    bashrcExtra = ''
    '';
  };
}
