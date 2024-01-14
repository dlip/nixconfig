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
    ./btop
  ];

  home.packages = with pkgs; [
    archivemount
    age
    air
    ansifilter
    autoreconfHook
    avrdude
    aws-google-auth
    patchelf
    nix-index
    stable.awscli2
    blisp
    docker-buildx
    cargo
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
    exiv2
    file
    fluxcd
    google-cloud-sdk
    ghc
    # ghostscript
    glow
    gnupg
    gnuplot
    go
    # gobang
    gotypist
    graphviz
    hexdino
    imagemagick
    jc
    joshuto
    jdk11
    kaf
    kind
    kubectl
    kubectx
    kubernetes-helm
    kubetail
    ledger
    ledger-autosync
    lldb
    lsof
    (lua.withPackages (ps: with ps; [luacheck]))
    mangal
    massren
    mdbook
    mdl
    mysql80
    # musikcube
    # myPythonPackages.shirah-reader
    # myPythonPackages.adafruit-nrfutil
    # ngrok
    niv
    nodePackages.node2nix
    nodePackages.pnpm
    nodePackages.quicktype
    nodePackages.reveal-md
    nodePackages.typescript
    nodejs
    notify-desktop
    notify
    openssl
    openvpn
    # openvpn_aws
    pandoc
    texlive.combined.scheme-medium
    typioca
    php
    pinentry
    # poetry
    postgresql
    python3
    # (python3.withPackages (ps: with ps; [evdev]))
    pwgen
    # python39Packages.grip
    # python39Packages.pip
    # python39Packages.pynvim
    # python39Packages.setuptools
    rclone
    redis
    renameutils
    # rustc
    # rustup
    sd
    # steel
    stern
    skopeo
    ssh-to-age
    tesseract4
    tio
    tldr
    # turbo
    ttyper
    terminal-typeracer
    unrar
    wireshark-cli
    ttyper
    typespeed
    vegeta
    # visidata #broken
    wasmtime
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
