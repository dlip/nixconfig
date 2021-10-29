{ config, pkgs, lib, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; });
  nvimHome = "${config.xdg.configHome}/nvim";
  # Test sha 0000000000000000000000000000000000000000000000000000
  extraPlugins = {
    # https://github.com/Pocco81/AutoSave.nvim
    autosave-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "autosave-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "Pocco81";
        repo = "AutoSave.nvim";
        rev = "e4cdc5bbfbfa57aa0e1a61d716cbe6697b1f3868";
        sha256 = "1cGFjvF9lZyVZySajEBc2BKMy99BJfVx4XojrjiqgEM=";
      };
    };
    # https://github.com/onsails/lspkind-nvim 
    lspkind-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "lspkind-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "onsails";
        repo = "lspkind-nvim";
        rev = "1557ce5b3b8e497c1cb1d0b9d967a873136b0c23";
        sha256 = "e82PbisrgQvk/ZG6XY7JajbRwpNOzlslDGH8ehrPLmM=";
      };
    };
    # https://github.com/NTBBloodbath/rest.nvim
    rest-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "rest-nvim";
      src = pkgs.fetchFromGitHub {
        owner = "NTBBloodbath";
        repo = "rest.nvim";
        rev = "5130e59f680df56f22bd8cc41da422f9a05580c5";
        sha256 = "s3jxCKxlCqovQ8GTbVo57CyEePJAWIgIGfgBrE3IGr0=";
      };
    };
    # https://github.com/glacambre/firenvim
    firenvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "firenvim";
      src = pkgs.fetchFromGitHub {
        owner = "glacambre";
        repo = "firenvim";
        rev = "eb3abef4520d17dbd9957f5d23ada74b853133e4";
        sha256 = "xXVWK13aKpGA0JNyOY+sPE8aiZlUsXwojiL3CwdsVGo=";
      };
    };
    # https://github.com/sebdah/vim-delve
    vim-delve = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "vim-delve";
      src = pkgs.fetchFromGitHub {
        owner = "sebdah";
        repo = "vim-delve";
        rev = "554b7997caba5d2b38bc4a092e3a468e4abb7f18";
        sha256 = "udfWUTQj3aNLi/OcDjdSNcXP6/MVVqNnq3xmjQffGoc=";
      };
    };
    # https://github.com/leoluz/nvim-dap-go
    nvim-dap-go = pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = "dap-go";
      src = pkgs.fetchFromGitHub {
        owner = "leoluz";
        repo = "nvim-dap-go";
        rev = "624a8b610083f8206cd3988cefb9549b8ffe2799";
        sha256 = "5FOEBf0+Gi+pnEqDeFT++XXFqIFVDjhTGsY37uHx+Rk=";
      };
    };
  };

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

      package = pkgs.neovim;

      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # Needed by Telescope
        bat
        fd
        ripgrep

        lldb # For nvim-dap

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
        source ${nvimHome}/myinit.vim
      '';

      plugins = with pkgs.vimPlugins // extraPlugins;
        let
          telescope = (pluginWithDeps telescope-nvim [ plenary-nvim popup-nvim telescope-frecency-nvim ]);
        in
        [
          autosave-nvim
          barbar-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-nvim-lua
          cmp-path
          cmp_luasnip
          comment-nvim
          dashboard-nvim
          diffview-nvim
          editorconfig-vim
          firenvim
          friendly-snippets
          glow-nvim
          gv-vim
          hop-nvim
          indent-blankline-nvim
          lspkind-nvim # Icons for lsp popup
          luasnip
          markdown-preview-nvim
          neogit
          neorg
          neoscroll-nvim
          nvim-autopairs
          nvim-cmp
          nvim-dap
          nvim-dap-go
          nvim-dap-ui
          nvim-lspconfig
          nvim-treesitter-textobjects
          nvim-ts-rainbow
          nvim-whichkey-setup-lua
          rest-nvim
          rust-tools-nvim
          tabular
          telescope
          telescope-dap-nvim
          tokyonight-nvim
          trouble-nvim
          undotree
          vim-delve
          vim-eunuch
          vim-fugitive
          vim-markdown
          vim-mergetool
          vim-rhubarb
          vim-solidity
          vim-test
          vim-tmux-navigator
          vim-which-key # spacemacs-like leader key menu
          vimwiki

          (pluginWithDeps gitsigns-nvim [ plenary-nvim ])
          (pluginWithDeps lualine-nvim [ lsp-status-nvim ])
          (pluginWithDeps nvim-tree-lua [ nvim-web-devicons ])
          (pluginWithDeps rust-tools-nvim [ telescope nvim-lspconfig ])
          (pluginWithDeps telescope-symbols-nvim [ telescope ])

          (nvim-treesitter.withPlugins builtins.attrValues)
        ];
    };
  };

  home.file = {
    "${nvimHome}" = {
      recursive = true;
      source = ./config;
    };
    "${nvimHome}/undo/.keep".text = "";
    "${nvimHome}/lua/env.lua".text = ''
      sumneko_root_path = "${pkgs.sumneko-lua-language-server}"
      awesome_root_path = "${awesomeSrc}"
      friendly_snippets_path = "${pkgs.vimPlugins.friendly-snippets}"
    '';
  };
}
