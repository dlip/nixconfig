{ lib
, stdenv
, perl
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "julius";
  version = "4.6";
  src = fetchFromGitHub {
    owner = "julius-speech";
    repo = pname;
    rev = "3b7174d0d4091f5e6ebb917769822032d079996f";
    sha256 = "1zf0y2v7h507gf1b3r8qqjapis1kkhjzd5msnzj3js17bwbx43cg";
  };
  enableParallelBuilding = true;
  buildInputs = [
    perl
  ];
  cmake = true;

}
