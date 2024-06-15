{pkgs, ...}: let
  extraPackages = with pkgs;
    if system == "aarch64-linux"
    then [
      # nodePackages.vscode-css-languageserver-bin
      # nodePackages.vscode-json-languageserver-bin
      # nodePackages.vscode-html-languageserver-bin
    ]
    else [
      # nodePackages.vscode-langservers-extracted dns issue
    ];
in {
  home.packages = with pkgs;
    [
      # alejandra # nix
      # codespell
      # gopls # golang
      # golangci-lint
      # haskellPackages.haskell-language-server
      # marksman # markdown
      # myNodePackages."@prisma/language-server"
      # nodePackages.bash-language-server
      # nodePackages.dockerfile-language-server-nodejs
      # nodePackages.eslint_d
      # nodePackages.intelephense # php
      # nodePackages.prettier
      # nodePackages.prettier_d_slim
      # nodePackages.pyright # python
      # nodePackages.typescript-language-server
      # nodePackages.vim-language-server
      # nodePackages.yaml-language-server
      # openscad-lsp
      # proselint
      # python311Packages.black
      # python311Packages.python-lsp-server
      # racket-minimal # requires `raco pkg install fmt`
      # rust-analyzer # rust
      # rustfmt
      # shfmt
      # solang
      # stylua
      # lua-language-server # arm error
      # taplo
      # terraform-ls
      # tree-sitter
      # vale
      # vim-vint
      # yamllint
    ]
    ++ extraPackages;
}
