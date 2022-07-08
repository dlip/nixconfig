{stdenv, pkgs, src}:
pkgs.mkYarnPackage {
    name = "actual-sync";
    inherit src;
    # buildPhase = ''
    #   runHook preBuild
    #   pushd deps/actual-sync
    #   yarn build
    #   popd
    #   runHook postBuild
    # '';
    postBuild = ''
      pushd ./deps/actual-sync
      yarn build
      # cp app.js index.js
      # mkdir -p $out/libexec/actual-sync
      # cp -R build/* $out/libexec/actual-sync
      # ls -la
      # cp -R "$node_modules" .
      popd
      # cp -R deps/actual-sync/build $out
    '';

    postInstall = ''
      rm $out/libexec/actual-sync/deps/actual-sync/node_modules
      cp -R "$node_modules" $out/libexec/actual-sync/deps/actual-sync/
    '';

    # postConfigure = ''
    #   cp -R "$node_modules" libexec/actual-sync/node_modules
    # '';

  #   preInstall = ''
  #   mkdir $out
  #   cp -R ./deps/lemmy-ui/dist $out
  #   cp -R ./node_modules $out
  # '';
    # publishBinsFor = ["actual-sync"];

    # postInstall = ''
    #   cp -R ./deps/actual-sync/build/* $out/libexec/actual-sync
    # '';

    # doDist = false;
  }

# let
#   nodeDependencies = (pkgs.callPackage ./import.nix { }).nodeDependencies;
# in
#
# stdenv.mkDerivation {
#   name = "my-webpack-app";
#   inherit src;
#   buildInputs = [ pkgs.nodejs ];
#   buildPhase = ''
#     ln -s ${nodeDependencies}/lib/node_modules ./node_modules
#     export PATH="${nodeDependencies}/bin:$PATH"
#
#     # Build the distribution bundle in "dist"
#     webpack
#     cp -r dist $out/
#   '';
# }
