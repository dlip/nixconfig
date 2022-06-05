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
    cp -r ${nodeDependencies}/lib/node_modules ./node_modules
    ls -la node_modules
    # ls -la node_modules/.bin
    # export PATH="${nodeDependencies}/bin:$PATH"
    # node_modules/gulp/bin/gulp.js build
    npm run build
    cp -r out $out/
  '';
}
