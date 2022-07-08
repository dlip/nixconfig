{ stdenv, pkgs, src, nodejs, fetchurl }:
let
  arch =
    if stdenv.hostPlatform.system == "x86_64-linux" then "linux-x64"
    else throw "Unsupported architecture: ${stdenv.hostPlatform.system}";

  bcrypt_version = "5.0.1";
  bcrypt_lib = fetchurl {
    url = "https://github.com/kelektiv/node.bcrypt.js/releases/download/v${bcrypt_version}/bcrypt_lib-v${bcrypt_version}-napi-v3-${arch}-glibc.tar.gz";
    sha256 = "3R3dBZyPansTuM77Nmm3f7BbTDkDdiT2HQIrti2Ottc=";
  };
in
pkgs.mkYarnPackage {
  name = "actual-sync";
  inherit src;
  postBuild = ''
    pushd node_modules/bcrypt
    mkdir -p ./lib/binding && tar -C ./lib/binding -xf ${bcrypt_lib}
    popd

    pushd ./deps/actual-sync
    yarn build
    popd
  '';
  postInstall = ''
    rm $out/libexec/actual-sync/deps/actual-sync/node_modules
    mv $out/libexec/actual-sync/node_modules $out/libexec/actual-sync/deps/actual-sync/node_modules
  '';

  doDist = false;
}
