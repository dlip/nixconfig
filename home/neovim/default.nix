{ config, pkgs, lib, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
  nvimHome = "${config.xdg.configHome}/nvim";
  # Test sha 0000000000000000000000000000000000000000000000000000
  extraPlugins = {
    nvim-dap-go = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "dap-go";
      src = pkgs.fetchFromGitHub {
        owner = "leoluz";
        repo = "nvim-dap-go";
        rev = "624a8b610083f8206cd3988cefb9549b8ffe2799";
        sha256 = "5FOEBf0+Gi+pnEqDeFT++XXFqIFVDjhTGsY37uHx+Rk=";
      };
    };
    autosave-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "autosave-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Pocco81";
        repo = "AutoSave.nvim";
        rev = "6af27430c47c8121e479c641381c3c220f38bace";
        sha256 = "7SFwfR8VTsPgLYj7BnGzTp3uee21BexgMW934V8DROo=";
      };
    };
    firenvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "firenvim";
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "eb3abef4520d17dbd9957f5d23ada74b853133e4";
        sha256 = "xXVWK13aKpGA0JNyOY+sPE8aiZlUsXwojiL3CwdsVGo=";
      };
    };
    vim-delve = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-delve";
      src = pkgs.fetchFromGitHub {
        owner = "sebdah";
        repo = "vim-delve";
        rev = "554b7997caba5d2b38bc4a092e3a468e4abb7f18";
        sha256 = "udfWUTQj3aNLi/OcDjdSNcXP6/MVVqNnq3xmjQffGoc=";
      };
    };
    lspkind-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "lspkind-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "onsails";
        repo = "lspkind-nvim";
        rev = "0f7851772ebdd5cb67a04b3d3cda5281a1eb83c1";
        sha256 = "fTIqhgDhQ3U7Kuqf/jMAAV2we6v7m0QbIHybji7tYUo=";
      };
    };
    nvim-cmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "nvim-cmp";
      src = pkgs.fetchFromGitHub {
        owner = "hrsh7th";
        repo = "nvim-cmp";
        rev = "f5393d5bd934428a469f03f5bc225922f8c48367";
        sha256 = "Cz20X1ICBjGXI2g170/oTdfSELOWc2BYjCQ5q0pDWj8=";
      };
    };
  };
in
{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      package = pkgs.neovim;

      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # Needed by Telescope
        bat
        fd
        ripgrep

        # For nvim-dap
        lldb

        # Various language servers
        #fenix.rust-analyzer
        nodePackages.bash-language-server
        clang-tools
        nodePackages.vscode-css-languageserver-bin
        nodePackages.dockerfile-language-server-nodejs
        gopls
        nodePackages.vscode-html-languageserver-bin
        nodePackages.pyright
        rnix-lsp
        terraform-ls
        nodePackages.typescript
        nodePackages.typescript-language-server
        sumneko-lua-language-server
      ];

      extraConfig = ''
        set undodir=${nvimHome}/undo
        set shadafile=${nvimHome}/viminfo
        let test#go#runner = 'gotest'
        lua require'init'
      '';

      plugins = with pkgs.vimPlugins // extraPlugins;
        let
          telescope = (pluginWithDeps telescope-nvim [ plenary-nvim popup-nvim telescope-frecency-nvim ]);
        in
        [
          autosave-nvim
          bufferline-nvim
          cmp_luasnip
          cmp-buffer
          cmp-nvim-lsp
          firenvim
          friendly-snippets
          luasnip
          lspkind-nvim # Icons for lsp popup
          neogit
          neoscroll-nvim
          nvim-cmp
          nvim-dap
          nvim-dap-go
          nvim-dap-ui
          nvim-treesitter-textobjects
          nvim-ts-rainbow
          nvim-whichkey-setup-lua
          rust-tools-nvim
          telescope
          telescope-dap-nvim
          tokyonight-nvim
          trouble-nvim
          vim-bbye
          vim-commentary
          vim-delve
          vim-easymotion
          vim-eunuch
          vim-test
          vim-tmux-navigator
          vim-which-key # spacemacs-like leader key menu

          (pluginWithDeps gitsigns-nvim [ plenary-nvim ])
          (pluginWithDeps lualine-nvim [ lsp-status-nvim ])
          (pluginWithDeps nvim-tree-lua [ nvim-web-devicons ])
          (pluginWithDeps rust-tools-nvim [ telescope nvim-lspconfig ])
          (pluginWithDeps telescope-symbols-nvim [ telescope ])

          nvim-lspconfig
          (
            nvim-treesitter.withPlugins
              (
                grammars:
                [
                  # TODO: package tree-sitt
                  grammars.tree-sitter-c
                  grammars.tree-sitter-cpp
                  grammars.tree-sitter-css
                  grammars.tree-sitter-go
                  grammars.tree-sitter-html
                  grammars.tree-sitter-java
                  grammars.tree-sitter-javascript
                  grammars.tree-sitter-jsdoc
                  grammars.tree-sitter-json
                  grammars.tree-sitter-lua
                  grammars.tree-sitter-markdown
                  grammars.tree-sitter-nix
                  grammars.tree-sitter-php
                  grammars.tree-sitter-python
                  grammars.tree-sitter-regex
                  grammars.tree-sitter-ruby
                  grammars.tree-sitter-rust
                  grammars.tree-sitter-tsx
                  grammars.tree-sitter-typescript
                  grammars.tree-sitter-yaml
                ]
              )
          )


          # editorconfig-vim

          # undotree
          # vim-easy-align
          # vim-fugitive
          # vim-surround
          # nvim-web-devicons
          # lsp-status-nvim
          # friendly-snippets
          # vim-polyglot
          # vim-jsonnet
          # goyo-vim
        ];
    };
  };

  home.file =
    let
      # Symlink everything in ./config to ~/.config/nvim/
      cfg = builtins.listToAttrs (
        map
          (
            file: {
              name = "${nvimHome}/${file}";
              value = {
                source = ./config + "/${file}";
                recursive = true;
              };
            }
          )
          (builtins.attrNames (builtins.readDir ./config))
      );
    in
    cfg // {
      "${nvimHome}/undo/.keep".text = "";
      "${nvimHome}/lua/env.lua".text = ''
        sumneko_root_path = "${pkgs.sumneko-lua-language-server}"
        friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
      '';
    };
}
