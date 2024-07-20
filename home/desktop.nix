{
  pkgs,
  lib,
  ...
}: {
  # services.dropbox.enable = true;
  imports = [
    ./alacritty
    # ./espanso
    ./k9s
  ];

  home.packages = with pkgs; [
    archivemount
    age
    air
    ansifilter
    autoreconfHook
    avrdude
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
    hottext
    speedread
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
    lldb
    lsof
    (lua.withPackages (ps: with ps; [luacheck]))
    massren
    mdbook
    mdl
    mysql80
    # musikcube
    # myPythonPackages.shirah-reader
    # myPythonPackages.adafruit-nrfutil
    # ngrok
    nix-init
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
    # poetry
    postgresql
    (python3.withPackages (ps: with ps; [pyusb tkinter]))
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
    typespeed
    vegeta
    # visidata #broken
    wasmtime
    yarn
    yarn2nix
    yt-dlp
    yq
    # yubikey-manager #broken
    zgrviewer
    zoxide
  ];
}
