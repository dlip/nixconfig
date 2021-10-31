{ pkgs, ... }: {
  imports = [
    ./joshuto
    ./xplr
  ];
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
    delve
    deno
    dig
    direnv
    dive
    docker-compose
    eksctl
    envy-sh
    exa
    fd # Better find
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
    gotop
    gopls
    graphviz
    haskellPackages.haskell-language-server
    hledger
    htop
    iotop
    joshuto
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
    lua
    luaformatter
    massren
    mdl
    myNodePackages.markserv
    ncdu
    neofetch
    niv
    nix-du
    nixfmt
    nixpkgs-fmt
    nmap
    nnn
    nodejs
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.eslint_d
    nodePackages.node2nix
    nodePackages.prettier
    nodePackages.quicktype
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    openvpn
    p7zip
    pandoc
    pinentry
    postgresql
    proselint
    python
    python3
    python39Packages.grip
    python39Packages.pip
    python39Packages.setuptools
    ripgrep
    ripgrep-all
    rnix-lsp
    rustup
    skopeo
    solang
    sops
    sqlite
    sumneko-lua-language-server
    stack
    tcpdump
    tektoncd-cli
    tesseract4
    tldr
    tshark
    unzip
    usbutils
    wally-cli
    wget
    xdotool
    yarn
    youtube-dl
    yubikey-manager
  ];
}
