{ config, pkgs, lib, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
  nvimHome = "${config.xdg.configHome}/nvim";
  extraPlugins = {
    nvim-dap-go = pkgs.vimUtils.buildVimPlugin {
      name = "dap-go";
      src = pkgs.fetchFromGitHub {
        owner = "leoluz";
        repo = "nvim-dap-go";
        rev = "624a8b610083f8206cd3988cefb9549b8ffe2799";
        sha256 = "5FOEBf0+Gi+pnEqDeFT++XXFqIFVDjhTGsY37uHx+Rk=";
      };
    };
    autosave-nvim = pkgs.vimUtils.buildVimPlugin {
      name = "autosave-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Pocco81";
        repo = "AutoSave.nvim";
        rev = "6af27430c47c8121e479c641381c3c220f38bace";
        sha256 = "7SFwfR8VTsPgLYj7BnGzTp3uee21BexgMW934V8DROo=";
      };
    };
    firenvim = pkgs.vimUtils.buildVimPlugin {
      name = "firenvim";
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "eb3abef4520d17dbd9957f5d23ada74b853133e4";
        sha256 = "xXVWK13aKpGA0JNyOY+sPE8aiZlUsXwojiL3CwdsVGo=";
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
        fenix.rust-analyzer
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
          telescope = (pluginWithDeps telescope-nvim [ plenary-nvim popup-nvim ]);
        in
        [
          autosave-nvim

          firenvim
          neogit
          nvim-compe
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
          vim-easymotion
          vim-eunuch
          vim-commentary
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
          # vim-vsnip
          # vim-vsnip-integ
          # friendly-snippets
          # lspkind-nvim
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
      '';
    };
}
