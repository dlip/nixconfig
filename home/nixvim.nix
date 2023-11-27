{...}: {
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      flavour = "macchiato";
    };
    clipboard.register = "unnamedplus"; # Use system clipboard
    options = {
      # Hybrid Line Numbers
      relativenumber = true; # Relative line numbers
      number = true; # Show current line number

      backup = false; # don't create backups
      swapfile = false; # Disable the swap file
      modeline = true; # Tags such as 'vim:ft=sh'
      modelines = 100; # Sets the type of modelines
      undofile = true; # Automatically save and restore undo history
      incsearch = true; # Incremental search: show match for partly typed search command
      ignorecase = true; # When the search query is lower-case, match both lower and upper-case
      smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
    };
    globals.mapleader = " ";
    keymaps = [
      {
        mode = "n";
        key = "U";
        action = "<C-r>";
        options.desc = "Redo";
      }
      {
        mode = "n";
        key = "<esc>";
        action = "<cmd>nohl<CR>";
        options = {
          desc = "No Highlight";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "ga";
        action = "<C-^>";
        options.desc = "Go to alternate file";
      }
      {
        mode = "n";
        key = "<CR>";
        action = "<cmd>wa<CR>";
        options = {
          desc = "Write all";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "Q";
        action = "@q";
        options.desc = "Replay macro recorded by qq";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = "<cmd>bd<CR>";
        options = {
          desc = "Delete Buffer";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>t";
        action = "<cmd>NvimTreeToggle<CR>";
        options = {
          desc = "Nvim Tree Toggle";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>Telescope frecency default_text=:CWD:<CR>";
        options = {
          desc = "Frequently Used Files";
          silent = true;
        };
      }
      # Window Splits
      {
        mode = ["n" "x" "o"];
        key = "<C-Up>";
        action = "<C-w>k";
        options.desc = "Go to the up window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Down>";
        action = "<C-w>j";
        options.desc = "Go to the down window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Left>";
        action = "<C-w>h";
        options.desc = "Go to the left window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Right>";
        action = "<C-w>l";
        options.desc = "Go to the right window";
      }
      # Git
      {
        mode = "n";
        key = "]g";
        action = "<cmd>Gitsigns next_hunk<Cr>";
        options = {
          desc = "Next git hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "[g";
        action = "<cmd>Gitsigns prev_hunk<Cr>";
        options = {
          desc = "Previous git hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gn";
        action = "<cmd>Neogit<Cr>";
        options = {
          desc = "Next git hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Gitsigns stages_hunk<Cr>";
        options = {
          desc = "Stage hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gb";
        action = "<cmd>Gitsigns blame_line<Cr>";
        options = {
          desc = "Blame Line";
          silent = true;
        };
      }
    ];
    plugins = {
      lightline.enable = true;
      which-key = {
        enable = true;
        registrations = {
        };
      };
      telescope = {
        enable = true;
        extensions.frecency.enable = true;
        keymaps = {
          "<leader>/" = {
            action = "live_grep";
            desc = "Grep";
          };
          "<leader>b" = {
            action = "buffers";
            desc = "Find Buffers";
          };
          "<leader>f" = {
            action = "find_files";
            desc = "Find Files";
          };
          "<leader>m" = {
            action = "man_pages";
            desc = "Search Manual";
          };
          "gr" = {
            action = "lsp_references";
            desc = "Goto references";
          };
        };
      };

      lsp = {
        enable = true;
        servers = {
          gopls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          tsserver.enable = true;
          yamlls.enable = true;
        };
        keymaps = {
          silent = true;
          diagnostic = {
            "[d" = {
              action = "goto_prev";
              desc = "Go to prev diagnostic";
            };
            "]d" = {
              action = "goto_next";
              desc = "Go to next diagnostic";
            };
          };

          lspBuf = {
            "<leader>a" = {
              action = "code_action";
              desc = "Code Actions";
            };
            "<leader>F" = {
              action = "format";
              desc = "Format";
            };
            "gd" = {
              action = "definition";
              desc = "Goto definition";
            };
            "gy" = {
              action = "type_definition";
              desc = "Goto Type Defition";
            };
            "gi" = {
              action = "implementation";
              desc = "Goto Implementation";
            };
            "k" = {
              action = "hover";
              desc = "Hover";
            };
          };
        };
      };

      lsp-format = {
        enable = true;
        lspServersToEnable = ["nil_ls"];
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
      };

      none-ls = {
        enable = true;
        sources = {
          formatting = {
            alejandra.enable = true;
            black.enable = true;
            eslint.enable = true;
            gofmt.enable = true;
            prettier.enable = true;
            shfmt.enable = true;
            stylua.enable = true;
            jq.enable = true;
            markdownlint.enable = true;
            rustfmt.enable = true;
          };
        };
      };
      gitsigns.enable = true;
      neogit.enable = true;
      comment-nvim.enable = true;
      nvim-tree = {
        enable = true;
        updateFocusedFile = {
          enable = true;
        };
        actions = {
          openFile = {
            quitOnOpen = true;
          };
        };
      };
      luasnip.enable = true;
      lspkind.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        sources = [
          {name = "path";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
        ];
        mapping = {
          "<Esc>" = "cmp.mapping.abort()";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
      };
    };
  };
}
