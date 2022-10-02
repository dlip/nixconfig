{ lib, stdenv, src, nodejs-16_x, callPackage, pkg-config, libsecret }:
let
  nodeDependencies = ((callPackage ./nodeModules { nodejs = nodejs-16_x; }).shell.override {
    inherit src;
    buildInputs = [ pkg-config libsecret ];
  }).nodeDependencies;
  nodeDependenciesProd = ((callPackage ./nodeModulesProd { nodejs = nodejs-16_x; }).shell.override {
    inherit src;
  }).nodeDependencies;
in

stdenv.mkDerivation {
  name = "vscode-node-debug2";
  inherit src;
  buildInputs = [ nodejs-16_x ];
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
