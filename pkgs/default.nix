{ pkgs, ... }:
with pkgs; {
  nodePackages = (callPackage ./nodePackages/default.nix { });
  skyscraper = (callPackage ./nodePackages/skyscraper.nix { });
}
