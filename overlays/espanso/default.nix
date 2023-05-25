{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  extra-cmake-modules,
  libX11,
  libXi,
  libXtst,
  libnotify,
  openssl,
  xclip,
  xdotool,
  makeWrapper,
  dbus,
  libxkbcommon,
  wxGTK31,
}:
rustPlatform.buildRustPackage rec {
  pname = "espanso";
  version = "2.1.6-beta";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = pname;
    rev = "v${version}";
    sha256 = "PTyxFGDO2xU3GbbSIskd5Q1KQoW5/6LmxaMjO888+EE=";
  };

  cargoSha256 = "Brzg0GyUEU52gWAagkz5aZCd+g5uL7RRhduIgcJFgZw=";

  nativeBuildInputs = [
    extra-cmake-modules
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    dbus
    libxkbcommon
    wxGTK31
    libX11
    libXtst
    libXi
    libnotify
    xclip
    openssl
    xdotool
  ];

  # Some tests require networking
  doCheck = false;

  preBuild = ''
    export PATH="${wxGTK31}/bin:$PATH"
  '';

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [libnotify xclip]}
  '';

  meta = with lib; {
    description = "Cross-platform Text Expander written in Rust";
    homepage = "https://espanso.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [kimat];
    platforms = platforms.linux;

    longDescription = ''
      Espanso detects when you type a keyword and replaces it while you're typing.
    '';
  };
}
