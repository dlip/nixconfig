extra:
{ pkgs, ... }: {
  home.packages = with pkgs;
    [
      awscli2
      bat
      cheat
      circleci-cli
      deno
      dive
      exa
      firefox
      fzf
      ghc
      go
      gopls
      haskellPackages.haskell-language-server
      htop
      jq
      metasploit
      nixfmt
      nixpkgs-fmt
      nodePackages.bash-language-server
      nodePackages.dockerfile-language-server-nodejs
      nodePackages.javascript-typescript-langserver
      nodePackages.typescript
      nodejs
      pandoc
      ripgrep
      rnix-lsp
      rustup
      sqlite
      stack
      tldr
      vim
      yarn
    ] ++ extra;
}
