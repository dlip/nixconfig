{ lib, stdenv, src, nodejs, callPackage, pkgconfig, libsecret }:
let
  nodeDependencies = ((callPackage ./nodeModules {}).shell.override {
    inherit src;
    buildInputs = [ pkgconfig libsecret ];
  }).nodeDependencies;
  nodeDependenciesProd = ((callPackage ./nodeModulesProd {}).shell.override {
    inherit src;
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
    mkdir $out
    cp -r out $out/
    cp package.json $out/
    cp -r ${nodeDependenciesProd}/lib/node_modules $out/node_modules
  '';
}
