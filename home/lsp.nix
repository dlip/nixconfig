{ pkgs, ... }: {
  home.packages = with pkgs; [
    haskellPackages.haskell-language-server
    luaformatter
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
    solang
    sumneko-lua-language-server
    terraform-ls
    tree-sitter
  ];
}
