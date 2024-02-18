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
    rev = "delay-oneshot-release-10ms";
    sha256 = "sha256-sBxpweUExqKTmbX0mx4eI2UsAiFd0R3XygbGrNY9V8U=";
  };

  cargoHash = "sha256-22cAxYAxX94r33FSdCdfoLu7oI/HDPGkY2U9Kqr6dPk=";

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
