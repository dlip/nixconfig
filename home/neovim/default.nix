{ config, pkgs, lib, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
  nvimHome = "${config.xdg.configHome}/nvim";
  symlinkedFiles = builtins.listToAttrs (
    map
      (
        file: {
          name = "${nvimHome}/${file}";
          value = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/neovim/config/${file}";
          };
        }
      )
      (builtins.attrNames (builtins.readDir ./config))
  );

  awesomeSrc = pkgs.fetchFromGitHub {
    owner = "awesomewm";
    repo = "awesome";
    rev = "v4.3";
    sha256 = "1i7ajmgbsax4lzpgnmkyv35x8vxqi0j84a14k6zys4blx94m9yjf";
  };
in
{
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      package = pkgs.neovim-unwrapped;

      extraConfig = ''
        let g:sumneko_root_path = "${pkgs.sumneko-lua-language-server}"
        let g:awesome_root_path = "${awesomeSrc}"
        let g:vscode_node_debug2_root_path = "${pkgs.dapAdapters.vscode-node-debug2}"
        let g:friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
        source ${nvimHome}/myinit.vim
      '';

      plugins = with pkgs.vimPlugins;
        let
          telescope = (pluginWithDeps telescope-nvim [ plenary-nvim popup-nvim telescope-frecency-nvim ]);
        in
        [
          asyncrun-vim
          # autosave-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp_luasnip
          comment-nvim
          dashboard-nvim
          diffview-nvim
          editorconfig-vim
          # fire-nvim
          format-nvim
          friendly-snippets
          glow-nvim
          gv-vim
          hop-nvim
          indent-blankline-nvim
          kmonad-vim
          lspkind-nvim # Icons for lsp popup
          lsp_signature-nvim
          luasnip
          markdown-preview-nvim
          # mkdx # E154: Duplicate tag "mkdx-setting-links-fragment-pumheight" in file /nix/store/n4fzja4lna666fym6w6jlnmsjfl5dj12-vimplugin-mkdx/./doc/mkdx.txtFailed to build help tags!
          neogit
          neorg
          neoscroll-nvim
          # nnn-nvim
          nord-nvim
          nui-nvim
          null-ls-nvim
          nvim-autopairs
          nvim-cmp
          nvim-dap
          # nvim-dap-go
          nvim-dap-ui
          nvim-dap-virtual-text
          nvim-lint
          nvim-lspconfig
          nvim-treesitter-textobjects
          nvim-ts-rainbow
          octo-nvim
          package-info-nvim
          rest-nvim
          tabular
          telescope
          telescope-dap-nvim
          tokyonight-nvim
          trouble-nvim
          undotree
          # vim-delve
          vim-dispatch
          vim-eunuch
          vim-fugitive
          vim-mergetool
          vim-rhubarb
          vim-solidity
          vim-test
          vim-tmux-navigator
          which-key-nvim

          (pluginWithDeps gitsigns-nvim [ plenary-nvim ])
          (pluginWithDeps lualine-nvim [ lsp-status-nvim ])
          (pluginWithDeps nvim-tree-lua [ nvim-web-devicons ])
          (pluginWithDeps rust-tools-nvim [ telescope nvim-lspconfig ])
          (pluginWithDeps telescope-symbols-nvim [ telescope ])

          (nvim-treesitter.withPlugins (plugins: with plugins; [
            # tree-sitter-bash
            # tree-sitter-c
            # tree-sitter-comment
            # tree-sitter-cpp
            # tree-sitter-css
            # tree-sitter-dot
            # tree-sitter-go
            # tree-sitter-haskell
            # tree-sitter-html
            # tree-sitter-javascript
            # tree-sitter-jsdoc
            # tree-sitter-json
            # tree-sitter-lua
            # tree-sitter-markdown
            # tree-sitter-nix
            # tree-sitter-python
            # tree-sitter-regex
            # tree-sitter-rust
            # tree-sitter-toml
            # tree-sitter-tsx
            # tree-sitter-typescript
            # tree-sitter-vim
            # tree-sitter-yaml
          ]))
        ];
    };
  };

  home.file = symlinkedFiles;
}
