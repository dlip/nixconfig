{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    alejandra
    codespell
    gopls
    golangci-lint
    haskellPackages.haskell-language-server
    nil
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.eslint_d
    nodePackages.prettier
    nodePackages.prettier_d_slim
    nodePackages.pyright
    nodePackages.typescript-language-server
    nodePackages.vscode-css-languageserver-bin
    nodePackages.vscode-html-languageserver-bin
    nodePackages.vscode-langservers-extracted
    nodePackages.vim-language-server
    nodePackages.yaml-language-server
    proselint
    rust-analyzer
    # rustfmt
    shfmt
    # solang
    stylua
    lua-language-server
    terraform
    taplo
    terraform-ls
    tree-sitter
    vale
    vim-vint
    yamllint
  ];
}
