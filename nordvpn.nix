# https://github.com/NixOS/nixpkgs/issues/101864#issuecomment-761230342
{ pkgs ? import <nixpkgs> { } }:

with pkgs;
stdenv.mkDerivation {
  name = "nordvpn";

  src = fetchurl {
    url =
      "https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn_3.8.8_amd64.deb";
    sha256 = "0v6r3wwnsk5pdjr188nip3pjgn1jrn5pc5ajpcfy6had6b3v4dwm";
  };

  nativeBuildInputs = [ dpkg ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" "distPhase" ];

  unpackPhase = "dpkg -x $src unpacked";

  installPhase = ''
    mkdir -p $out/usr
    cp -r unpacked/* $out/
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/usr/bin/nordvpn
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/usr/sbin/nordvpnd
  '';

}
