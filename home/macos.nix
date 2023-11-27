{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./default.nix
    ./yabai
    ./skhd
    ./desktop.nix
    ./graphical.nix
  ];

  home.packages = with pkgs; [
    iterm2
  ];

  home.activation = {
    trampolineApps = let
      apps = pkgs.buildEnv {
        name = "home-manager-applications";
        paths = config.home.packages;
        pathsToLink = "/Applications";
      };
      mac-app-util = pkgs.mac-app-util.packages.${pkgs.stdenv.system}.default;
    in
      lib.hm.dag.entryAfter ["writeBoundary"] ''
        fromDir="${apps}/Applications/"
        toDir="$HOME/Applications/Home Manager Trampolines"
        ${mac-app-util}/bin/mac-app-util sync-trampolines "$fromDir" "$toDir"
      '';
  };
}
