{ pkgs, ... }:
with pkgs; {
  nodePackages = (callPackage ./nodePackages/default.nix { });
}
