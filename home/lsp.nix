{pkgs, ...}: let
  extraPackages = with pkgs.unstable;
    if system == "aarch64-linux"
    then [
      nodePackages.vscode-css-languageserver-bin
      nodePackages.vscode-json-languageserver-bin
      nodePackages.vscode-html-languageserver-bin
    ]
    else [
      # nodePackages.vscode-langservers-extracted dns issue
    ];
in {
  home.packages = with pkgs.unstable;
    [
      alejandra
      codespell
      gopls
      golangci-lint
      haskellPackages.haskell-language-server
      nil
      myNodePackages."@prisma/language-server"
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.eslint_d
      nodePackages.intelephense # php
      nodePackages.prettier
      nodePackages.prettier_d_slim
      nodePackages.pyright
      nodePackages.typescript-language-server
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
    ]
    ++ extraPackages;
}
