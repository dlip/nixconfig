{ pkgs, ... }: {
  home.packages = with pkgs; [
    appimage-run
    arion
    autoreconfHook
    aws-google-auth
    awscli2
    bat
    binutils
    cheat
    circleci-cli
    csvkit
    deno
    dig
    direnv
    dive
    docker-compose
    eksctl
    envy-sh
    exa
    file
    fluxcd
    fzf
    gcc
    gh
    ghc
    gnumake
    gnupg
    gnuplot
    go
    gopls
    graphviz
    haskellPackages.haskell-language-server
    hledger
    htop
    iotop
    jq
    k9s
    kind
    kubectl
    kubernetes-helm
    kubetail
    mdl
    my.nodePackages.unified-language-server
    ncdu
    neofetch
    nixfmt
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.node2nix
    nodePackages.pnpm
    nodePackages.prettier
    nodePackages.quicktype
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.yaml-language-server
    nodejs
    openvpn
    pandoc
    pinentry
    proselint
    python
    python3
    python38Packages.grip
    python38Packages.pip
    python38Packages.setuptools
    ripgrep
    rnix-lsp
    rustup
    skopeo
    sops
    sqlite
    stack
    tcpdump
    tektoncd-cli
    terraform_0_15
    tldr
    tshark
    usbutils
    vim
    yarn
    yubikey-manager
  ];
}
