{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    acpi
    age
    air
    appimage-run
    autoreconfHook
    avrdude
    aws-google-auth
    awscli2
    bat
    binutils
    cheat
    clang-tools
    deno
    dive
    docker-compose
    eksctl
    file
    fluxcd
    gcc
    gh
    ghc
    ghostscript
    glow
    gnupg
    gnuplot
    go
    gobang
    graphviz
    hledger
    k9s
    kind
    kmonad
    kubectl
    kubernetes-helm
    kubetail
    ledger
    ledger-autosync
    lldb
    (lua.withPackages (ps: with ps; [ luacheck ]))
    massren
    mdl
    niv
    nix-du
    nodePackages.node2nix
    nodePackages.quicktype
    nodePackages.reveal-md
    nodePackages.typescript
    nodejs
    openssl
    openvpn
    pandoc
    pinentry
    postgresql
    python
    python3
    python39Packages.grip
    python39Packages.pip
    python39Packages.setuptools
    rclone
    renameutils
    rustup
    skopeo
    sops
    sqlite
    ssh-to-age
    tesseract4
    tldr
    tshark
    usbutils
    visidata
    wally-cli
    xdotool
    yarn
    youtube-dl
    yq
    yubikey-manager
  ];
}
