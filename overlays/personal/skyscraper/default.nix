{ stdenv, qt5, fetchFromGitHub, ... }:

stdenv.mkDerivation {
  name = "skyscraper";

  buildInputs = [
    qt5.qmake
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp Skyscraper $out/bin/
  '';

  src = fetchFromGitHub {
    repo = "skyscraper";
    owner = "muldjord";
    rev = "f98480be6607608bfe07f83cab097bcfeff086c3";
    sha256 = "CqGCUxvGuQ7JgkwhNUaEeFFgZPfyzdG1i8fVgkCOv0M=";
  };
}
