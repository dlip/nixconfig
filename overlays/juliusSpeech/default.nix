{ lib
, stdenv
, perl
, libpulseaudio
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "julius";
  version = "4.6";
  src = fetchFromGitHub {
    owner = "julius-speech";
    repo = pname;
    rev = "4ba475bd430faa5919e13e2020d6edda1491fb66";
    sha256 = "CHRTz0ijikml9IinNHelhNpL6YwN3RAKuqJzH+iU5vw=";
  };
  enableParallelBuilding = true;
  buildInputs = [
    perl
    libpulseaudio
  ];
  configureFlags = [ "--enable-words-int" "--with-mictype=pulseaudio" ];
  cmake = true;

}
