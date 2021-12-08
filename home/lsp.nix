{ pkgs, ... }: {
  home.packages = with pkgs; [
    codespell
    gopls
    golangci-lint
    haskellPackages.haskell-language-server
    myNodePackages.markserv
    nixfmt
    nixpkgs-fmt
    nodePackages.bash-language-server
    # nodePackages.dockerfile-language-server-nodejs
    nodePackages.eslint_d
    nodePackages.prettier
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    proselint
    rnix-lsp
    shfmt
    solang
    stylua
    sumneko-lua-language-server
    terraform-ls
    tree-sitter
    vale
  ];
}
