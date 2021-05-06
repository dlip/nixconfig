{ pkgs, ... }: {
  home.packages = with pkgs; [
    appimage-run
    autoreconfHook
    aws-google-auth
    awscli2
    bat
    binutils
    cheat
    circleci-cli
    deno
    dig
    direnv
    dive
    docker-compose
    eksctl
    exa
    file
    firefox-devedition-bin
    fzf
    gcc
    ghc
    gnumake
    gnuplot
    go
    gopls
    graphviz
    haskellPackages.haskell-language-server
    hledger
    htop
    jq
    kubectl
    kubernetes-helm
    kubetail
    mdl
    neofetch
    nixfmt
    nixpkgs-fmt
    nodePackages.pnpm
    nodejs
    openvpn
    pandoc
    proselint
    python
    python3
    python39Packages.grip
    python38Packages.pip
    python38Packages.setuptools
    ripgrep
    rnix-lsp
    rustup
    sqlite
    stack
    terraform_0_15
    tldr
    vim
    yarn
  ];
}
