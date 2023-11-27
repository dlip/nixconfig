{...}: {
  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
      flavour = "macchiato";
    };
    options = {
      # Hybrid Line Numbers
      relativenumber = true; # Relative line numbers
      number = true; # Show current line number
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
        options.desc = "No Highlight";
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
        action = ":wa<CR>";
        options.desc = "Write all";
      }
      {
        mode = "n";
        key = "<leader>x";
        action = ":bd<CR>";
        options.desc = "Delete Buffer";
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
        keymaps = {
          "<leader>/" = {
            action = "live_grep";
            desc = "Grep";
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
          nil_ls.enable = true;
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
    };
  };
}
