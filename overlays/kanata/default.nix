{
  stdenv,
  lib,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  withCmd ? false,
  src,
}:
rustPlatform.buildRustPackage rec {
  pname = "kanata";
  version = "1.7.0";
  inherit src;

  # src = fetchFromGitHub {
  #   owner = "jtroo";
  #   repo = pname;
  #   rev = "cebf123b0c4cda8592fa3a09f98cb78e4c8f9f61";
  #   sha256 = "sha256-cg0lEbA+ou/HWcjkpmQLpGTYoJ54INVgJLQq1PCU7RQ=";
  # };

  cargoHash = "sha256-QyMvzMJDf2Bc9/61nI9TwNRrHNE+bol9SpEO/QsxmPM=";

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
