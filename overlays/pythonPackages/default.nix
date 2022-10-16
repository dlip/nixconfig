{ pkgs, ... }:
let packages = pkgs.poetry2nix.mkPoetryPackages {
  projectDir = ./.;
  python = pkgs.python3;
};
in
builtins.listToAttrs
  (map
    (p: {
      name = p.pname;
      value = p;
    })
   (packages.poetryPackages))
