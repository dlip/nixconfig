{ pkgs, ... }: {
  home.packages = with pkgs; [
    awscli2
    bat
    cheat
    circleci-cli
    deno
    dive
    direnv
    docker-compose
    exa
    eksctl
    firefox
    fzf
    ghc
    go
    gopls
    haskellPackages.haskell-language-server
    htop
    jq
    kubectl
    nixfmt
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.javascript-typescript-langserver
    nodePackages.typescript
    nodejs
    openvpn
    pandoc
    ripgrep
    rnix-lsp
    rustup
    sqlite
    stack
    tldr
    vim
    yarn
  ];
}
