{ pkgs, ... }:
with pkgs; {
  nodePackages = (callPackage ./nodePackages { });
  skyscraper = (callPackage ./skyscraper { });
}
