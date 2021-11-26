{ stdenv, fetchurl, autoPatchelfHook, pkgs, zlib }:
stdenv.mkDerivation {
  name = "solang";
  src = fetchurl {
    url = "https://github.com/hyperledger-labs/solang/releases/download/v0.1.8/solang-linux";
    sha256 = "sha256-+qezaj8+s/oYR0VaHntW3RucMth5IfOQ6tcwhBw4qKE=";
  };
  nativeBuildInputs = [
    autoPatchelfHook
    stdenv.cc.cc.lib
    zlib
  ];
  unpackPhase = "true";
  installPhase = ''
    install -m755 -D $src $out/bin/solang
  '';
}
#
# { lib, fetchFromGitHub, rustPlatform }:
#
# rustPlatform.buildRustPackage rec {
#   pname = "solang";
#   version = "12.1.1";
#
#   src = fetchFromGitHub {
#     owner = "hyperledger-labs";
#     repo = "solang";
#     rev = "b34320a96230f0eb712bd94a9e2f268218b65161";
#     sha256 = "pWpuk8Wjzqv01/pcK867D59Hr+jlXOvWLY3HT8knrnw=";
#   };
#
#   cargoLock = {
#     lockFileContents = builtins.readFile ./Cargo.lock;
#   };
#
#   meta = with lib; {
#     description = "A fast line-oriented regex search tool, similar to ag and ack";
#     homepage = "https://github.com/BurntSushi/ripgrep";
#     license = licenses.unlicense;
#     maintainers = [ maintainers.tailhook ];
#   };
# }
#
