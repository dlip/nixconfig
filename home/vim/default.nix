{ config, pkgs, lib, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
  nvimHome = "${config.xdg.configHome}/nvim";
in
{
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
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
      ];

      # Can't rely on init.lua, because it gets loaded before init.vim and
      # home-manager sets things like runtimepath and packpath in it
      # TODO: make that use ~/.local/share/nvim instead
      extraConfig = ''
        set backupdir=${nvimHome}/backups
        set directory=${nvimHome}/swaps
        set undodir=${nvimHome}/undo
        set shadafile=${nvimHome}/viminfo

        lua require'my'
        runtime config.vim
      '';

      plugins = with pkgs.vimPlugins;
        let
          telescope =
            (pluginWithDeps telescope-nvim [ plenary-nvim popup-nvim ]);
        in
          [
            (pluginWithDeps gruvbox-nvim [ lush-nvim ])
            undotree
            vim-fugitive
            vim-surround
            vim-easy-align
            editorconfig-vim

            plenary-nvim
            popup-nvim
            telescope

            nvim-lspconfig
            (
              nvim-treesitter.withPlugins (
                grammars:
                  [
                    # TODO: package tree-sitter-comment
                    grammars.tree-sitter-bash
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
            nvim-web-devicons
            (pluginWithDeps nvim-tree-lua [ nvim-web-devicons ])
            (pluginWithDeps gitsigns-nvim [ plenary-nvim ])
            (pluginWithDeps rust-tools-nvim [ telescope nvim-lspconfig ])
            (pluginWithDeps telescope-symbols-nvim [ telescope ])
            nvim-compe
            lsp-status-nvim
            vim-vsnip
            vim-vsnip-integ
            friendly-snippets
            lspkind-nvim
            lualine-nvim
            trouble-nvim

            nvim-dap
            telescope-dap-nvim
            rust-tools-nvim

            # lightline-vim

            vim-polyglot
            vim-jsonnet
            goyo-vim
          ];
    };
  };

  home.file =
    let
      # Symlink everything in ./config to ~/.config/nvim/
      cfg = builtins.listToAttrs (
        map (
          file: {
            name = "${nvimHome}/${file}";
            value = {
              source = ./config + "/${file}";
              recursive = true;
            };
          }
        ) (builtins.attrNames (builtins.readDir ./config))
      );
    in
      cfg // {
        "${nvimHome}/undo/.keep".text = "";
        "${nvimHome}/swaps/.keep".text = "";
        "${nvimHome}/backups/.keep".text = "";
      };
}
