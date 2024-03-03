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
    rev = "634ed973ce9aa2a6e22aa162efad0e1a493e985b";
    sha256 = "sha256-Vz1UwDRxlSl1k4GoNGgsP0DhvNbyF8RmWPYJ/3FY/KM=";
  };

  cargoHash = "sha256-Om24NNpV26Ef7MDzuWVMeUou8bXgL9NTUCWsCZ9F4Ic=";

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
