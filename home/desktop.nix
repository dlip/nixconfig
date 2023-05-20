{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./alacritty
    ./espanso
    ./k9s
    ./syncthing
  ];

  home.packages = with pkgs.unstable; [
    acpi
    age
    air
    ansifilter
    appimage-run
    autoreconfHook
    avrdude
    aws-google-auth
    pkgs.awscli2
    binutils
    docker-buildx
    # cargo
    cargo-wasi
    cheat
    clang-tools
    clamav
    delve
    deno
    dive
    difftastic
    docker-compose
    eksctl
    evtest
    exiv2
    file
    fluxcd
    fusee-launcher
    google-cloud-sdk
    ghc
    # ghostscript
    glow
    gnupg
    gnuplot
    go
    gobang
    gotypist
    graphviz
    hexdino
    heimdall
    hledger
    imagemagick
    joshuto
    pkgs.iredis
    jdk11
    kind
    kmonad
    krename
    kubectl
    kubectx
    kubernetes-helm
    kubetail
    ledger
    ledger-autosync
    lldb
    (lua.withPackages (ps: with ps; [luacheck]))
    mangal
    massren
    mdl
    mysql80
    # musikcube
    # myPythonPackages.shirah-reader
    # myPythonPackages.adafruit-nrfutil
    niv
    nix-du
    nodePackages.node2nix
    nodePackages.pnpm
    nodePackages.quicktype
    nodePackages.reveal-md
    nodePackages.typescript
    nodejs
    notify
    openssl
    openvpn
    # openvpn_aws
    pandoc
    texlive.combined.scheme-medium
    php
    pinentry
    # poetry
    postgresql
    python3
    pwgen
    # python39Packages.grip
    # python39Packages.pip
    # python39Packages.pynvim
    # python39Packages.setuptools
    rclone
    renameutils
    # rustc
    rustup
    sd
    stern
    strace
    skopeo
    ssh-to-age
    teams
    tesseract4
    tldr
    traceroute
    # turbo
    unrar
    wireshark-cli
    ttyper
    typespeed
    usbutils
    vegeta
    ventoy
    # visidata #broken
    wasmtime
    xdotool
    yarn
    yarn2nix
    youtube-dl
    yt-dlp
    yq
    # yubikey-manager #broken
    zgrviewer
    zoxide
  ];
}
