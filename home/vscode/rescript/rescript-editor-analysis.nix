{ stdenv, fetchFromGitHub, bash, ocaml }:
stdenv.mkDerivation {
  name = "rescript-editor-analysis";
  src = fetchFromGitHub {
      owner = "rescript-lang";
      repo = "rescript-vscode";
      rev = "8d0412a72307b220b7f5774e2612760a2d429059";
      sha256 = "rHQtfuIiEWlSPuZvNpEafsvlXCj2Uv1YRR1IfvKfC2s=";
    };
  nativeBuildInputs = [ ocaml ];

  buildPhase = ''
    cd analysis
    sed -i 's|/bin/bash|${bash}/bin/bash|g' Makefile
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./rescript-editor-analysis.exe $out/bin
  '';
}