{ stdenv, fetchFromGitHub, pkgs }:
let
  src = fetchFromGitHub {
      name = "rescript-vscode";
      owner = "rescript-lang";
      repo = "rescript-vscode";
      rev = "8d0412a72307b220b7f5774e2612760a2d429059";
      sha256 = "rHQtfuIiEWlSPuZvNpEafsvlXCj2Uv1YRR1IfvKfC2s=";
    };

in stdenv.mkDerivation {
  inherit src;
  name = "rescript-editor-analysis";
  nativeBuildInputs = with pkgs; [ bash ocaml ];

  installPhase = with pkgs; ''
    set -euo pipefail
    cd analysis
    sed -i 's|/bin/bash|${bash}/bin/bash|g' Makefile
    make
    mkdir -p $out/bin
    cp ./rescript-editor-analysis.exe $out/bin
  '';
}