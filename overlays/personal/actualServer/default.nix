{stdenv, pkgs, src}:
let
  nodeDependencies = (pkgs.callPackage ./default.nix { }).nodeDependencies;
in

stdenv.mkDerivation {
  name = "my-webpack-app";
  inherit src;
  buildInputs = [ nodejs ];
  buildPhase = ''
    ln -s ${nodeDependencies}/lib/node_modules ./node_modules
    export PATH="${nodeDependencies}/bin:$PATH"

    # Build the distribution bundle in "dist"
    webpack
    cp -r dist $out/
  '';
}
