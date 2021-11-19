{ pkgs, ... }: {
  home.packages = with pkgs; [
    appimage-run
    autoreconfHook
    avrdude
    aws-google-auth
    awscli2
    bat
    binutils
    cheat
    circleci-cli
    clang-tools
    delve
    deno
    dig
    direnv
    dive
    docker-compose
    easyeffects
    eksctl
    envy-sh
    exa
    fd
    file
    fluxcd
    fzf
    gcc
    gh
    ghc
    glow
    gnumake
    gnupg
    gnuplot
    go
    gobang
    gopls
    gotop
    graphviz
    hledger
    htop
    iotop
    jq
    k9s
    killall
    kind
    kmonad
    kubectl
    kubernetes-helm
    kubetail
    lazygit
    ledger
    ledger-autosync
    lldb
    lua
    massren
    mdl
    ncdu
    neofetch
    niv
    nix-du
    nixfmt
    nixpkgs-fmt
    nmap
    nodePackages.node2nix
    nodePackages.quicktype
    nodePackages.typescript
    nodejs
    nvimpager
    openvpn
    p7zip
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
    ripgrep
    ripgrep-all
    rustup
    skopeo
    sops
    sqlite
    stack
    tcpdump
    tesseract4
    tldr
    tshark
    unzip
    usbutils
    visidata
    wally-cli
    wget
    xdotool
    yarn
    youtube-dl
    yubikey-manager
  ];
}
