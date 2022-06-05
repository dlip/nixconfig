{ lib, stdenv, src, nodejs, callPackage, pkgconfig, libsecret }:
let
  nodeDependencies = ((callPackage ./nodeModules {}).shell.override {
    inherit src;
    buildInputs = [ pkgconfig libsecret ];
  }).nodeDependencies;
in

stdenv.mkDerivation {
  name = "vscode-node-debug2";
  inherit src;
  buildInputs = [nodejs];
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    npm run build
  '';

  installPhase = ''
    cp -r out $out/
  '';
}
