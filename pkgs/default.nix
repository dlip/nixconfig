{ pkgs, ... }:
with pkgs; {
  nodePackages = (callPackage ./nodePackages/default.nix { });
  skyscraper = (callPackage ./skyscraper/default.nix { });
}
