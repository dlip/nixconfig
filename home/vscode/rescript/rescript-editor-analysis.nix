{ lib, stdenv, fetchFromGitHub, bash, ocaml }:

stdenv.mkDerivation {
  pname = "rescript-editor-analysis";
  version = "1.1.3";

  src = (fetchFromGitHub {
    owner = "rescript-lang";
    repo = "rescript-vscode";
    rev = "8d0412a72307b220b7f5774e2612760a2d429059";
    sha256 = "rHQtfuIiEWlSPuZvNpEafsvlXCj2Uv1YRR1IfvKfC2s=";
  }) + "/analysis";

  nativeBuildInputs = [ ocaml ];

  postPatch = ''
    sed -i 's|/bin/bash|${bash}/bin/bash|g' Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./rescript-editor-analysis.exe $out/bin
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
