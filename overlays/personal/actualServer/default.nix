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

  bettersqlite3_version = "7.5.0";
  bettersqlite3_lib = fetchurl {
    url = "https://github.com/WiseLibs/better-sqlite3/releases/download/v${bettersqlite3_version}/better-sqlite3-v${bettersqlite3_version}-node-v93-linux-x64.tar.gz";
    sha256 = "sha256-n9OvLPm2XuzaJjbikPeAr96eCVNukK2Cn0KaKLIIRws=";
  };

in
pkgs.mkYarnPackage {
  name = "actual-sync";
  inherit src;
  postBuild = ''
    pushd node_modules/bcrypt
    mkdir -p ./lib/binding && tar -C ./lib/binding -xf ${bcrypt_lib}
    popd
    pushd node_modules/better-sqlite3
    tar xf ${bettersqlite3_lib}
    popd
  '';

  postInstall = ''
    mv $out/libexec/actual-sync/deps/actual-sync $out/src
    rm $out/src/node_modules
    mv $out/libexec/actual-sync/node_modules $out/src/node_modules
    rm -rf $out/libexec

    cp ${./config.js} $out/src/load-config.js
    cat > $out/bin/actual-server <<EOF
      #! ${stdenv.shell} -e
      ${nodejs}/bin/node $out/src/app.js
    EOF
    chmod +x $out/bin/actual-server
  '';

  doDist = false;
}
