{
  stdenv,
  lib,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  withCmd ? false,
}:
rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "jtroo";
    repo = pname;
    rev = "d60524ab340efd0e49acd3ad256959173f33b6e0";
    sha256 = "sha256-S5UyvzFA8JB+0WOo2CbqpFaU7S0amPNqs3ynXl9H5KQ=";
  };

  cargoHash = "sha256-Y0EROsgnz3gDzw06/Fz08tqOk/lJMoTcbbZS62t4kCY=";

  buildInputs = lib.optionals stdenv.isDarwin [darwin.apple_sdk.frameworks.IOKit];

  buildFeatures = lib.optional withCmd "cmd";

  # Workaround for https://github.com/nixos/nixpkgs/issues/166205
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_LDFLAGS = "-l${stdenv.cc.libcxx.cxxabi.libName}";
  };

  postInstall = ''
    install -Dm 444 assets/kanata-icon.svg $out/share/icons/hicolor/scalable/apps/kanata.svg
  '';

  meta = with lib; {
    description = "A tool to improve keyboard comfort and usability with advanced customization";
    homepage = "https://github.com/jtroo/kanata";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [bmanuel linj];
    platforms = platforms.unix;
    mainProgram = "kanata";
  };
}
