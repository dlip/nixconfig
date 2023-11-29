{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    enableMan = false; # https://github.com/nix-community/nixvim/issues/754

    colorschemes.catppuccin = {
      enable = true;
      flavour = "macchiato";
      integrations = {
        cmp = true;
        gitsigns = true;
        treesitter = true;
        telescope = {
          enabled = true;
        };
        markdown = true;
      };
    };
    clipboard.register = "unnamedplus"; # Use system clipboard
    options = {
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
      expandtab = true; # use spaces instead of tabs
      shiftwidth = 2; # shift 2 spaces when tab
      tabstop = 4; # 1 tab == 4 spaces
      smartindent = true; # autoindent new lines
      lazyredraw = true; # faster scrolling
      list = true; # show hidden characters
      listchars = {
        trail = "•"; # trailing space
      };
    };
    autoCmd = [
      {
        # Restore enter in quickfix
        event = ["FileType"];
        pattern = ["qf"];
        command = "nmap <buffer> <CR> <CR>";
      }
      {
        # Quit quickfix with q
        event = ["FileType"];
        pattern = ["qf"];
        command = "nmap <buffer><silent> q :ccl<CR>";
      }
      {
        # Quit help with q
        event = ["FileType"];
        pattern = ["help"];
        command = "nmap <buffer><silent> q :q<CR>";
      }
    ];
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
        mode = "x";
        key = "p";
        action = "P";
        options.desc = "Paste without yank";
      }
      {
        mode = "n";
        key = "x";
        action = "\"_x";
        options.desc = "Delete without yank";
      }
      {
        mode = "n";
        key = "X";
        action = "\"_X";
        options.desc = "Backspace without yank";
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
      {
        mode = "n";
        key = "<leader>y";
        action = "<cmd>let @+=expand('%').':'.line('.')<CR>";
        options = {
          desc = "Yank filename";
          silent = true;
        };
      }
      # Window Splits
      {
        mode = ["n" "x" "o"];
        key = "<C-Up>";
        action = "<cmd>TmuxNavigateUp<CR>";
        options.desc = "Go to the up window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Down>";
        action = "<cmd>TmuxNavigateDown<CR>";
        options.desc = "Go to the down window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Left>";
        action = "<cmd>TmuxNavigateLeft<CR>";
        options.desc = "Go to the left window";
      }
      {
        mode = ["n" "x" "o"];
        key = "<C-Right>";
        action = "<cmd>TmuxNavigateRight<CR>";
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
        key = "<leader>n";
        action = "<cmd>Neogit<Cr>";
        options = {
          desc = "Neogit";
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
      {
        mode = "n";
        key = "<leader>gx";
        action = "<cmd>Gitsigns reset_hunk<Cr>";
        options = {
          desc = "Reset hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gc";
        action = "<cmd>Telescope git_signs<CR>";
        options = {
          desc = "Changes in buffer";
          silent = true;
        };
      }
    ];
    plugins = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
      which-key = {
        enable = true;
        registrations = {
          "<leader>g" = "Git";
          "<leader>gy" = "Yank git link";
          "<leader>h" = "Harpoon Add";
          "<leader>H" = "Harpoon Menu";
          "<leader>1" = "Harpoon 1";
          "<leader>2" = "Harpoon 2";
          "<leader>3" = "Harpoon 3";
          "<leader>4" = "Harpoon 4";
          "<leader>," = "Previous Harpoon";
          "<leader>." = "Next Harpoon";
        };
      };
      telescope = {
        enable = true;
        extensions.frecency.enable = true;
        enabledExtensions = ["git_signs"];
        keymaps = {
          "<leader>'" = {
            action = "resume";
            desc = "Resume Telescope";
          };
          "<leader>b" = {
            action = "buffers";
            desc = "Find Buffers";
          };
          "<leader>d" = {
            action = "diagnostics";
            desc = "Diagnostics";
          };
          "<leader>f" = {
            action = "find_files";
            desc = "Find Files";
          };
          "<leader>m" = {
            action = "man_pages";
            desc = "Search Manual";
          };
          "<leader>p" = {
            action = "live_grep";
            desc = "Grep";
          };
          "<leader>s" = {
            action = "lsp_document_symbols";
            desc = "Symbols";
          };
          "<leader>S" = {
            action = "lsp_dynamic_workspace_symbols";
            desc = "Workspace Symbols";
          };
          "gr" = {
            action = "lsp_references";
            desc = "Goto references";
          };
        };
        extraOptions = {
          pickers = {find_files = {hidden = true;};};
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
            "<leader>r" = {
              action = "rename";
              desc = "Rename Symbol";
            };
            "<leader>F" = {
              action = "format";
              desc = "Format";
            };
            "gd" = {
              action = "definition";
              desc = "Goto definition";
            };
            "gD" = {
              action = "declaration";
              desc = "Goto declaration";
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

      lsp-format.enable = true;
      nvim-autopairs.enable = true;
      leap.enable = true;
      indent-blankline = {
        enable = true;
        scope.enabled = false;
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
      };
      treesitter-context.enable = true;

      none-ls = {
        enable = true;
        # onAttach = "require('lsp-format').on_attach";
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
      gitlinker.enable = true;
      neogit = {
        enable = true;
        autoRefresh = true;
      };
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
      harpoon = {
        enable = true;

        enableTelescope = true;
        keymapsSilent = true;
        keymaps = {
          addFile = "<leader>h";
          navFile = {
            "1" = "<leader>1";
            "2" = "<leader>2";
            "3" = "<leader>3";
            "4" = "<leader>4";
          };
          navNext = "<leader>.";
          navPrev = "<leader>,";
          toggleQuickMenu = "<leader>H";
        };
      };
      tmux-navigator.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [{paths = "${pkgs.vimPlugins.friendly-snippets}";}];
      };
      lspkind.enable = true;
      nvim-cmp = {
        enable = true;
        snippet.expand = "luasnip";
        sources = [
          {name = "path";}
          {name = "nvim_lsp";}
          {name = "luasnip";}
          {
            name = "buffer";
            # Words from other open buffers can also be suggested.
            option.get_bufnrs.__raw = "vim.api.nvim_list_bufs";
          }
        ];
        mapping = {
          "<Esc>" = {
            action = ''
              function(fallback)
                if cmp.visible() then
                  vim.defer_fn(function() vim.cmd('stopinsert') end, 1)
                  cmp.abort()
                else
                  fallback()
                end
              end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<Tab>" = {
            action = ''
                   function(fallback)
              local luasnip = require("luasnip")
                     if cmp.visible() then
                       cmp.select_next_item()
                     elseif luasnip.expandable() then
                       luasnip.expand()
                     elseif luasnip.expand_or_jumpable() then
                       luasnip.expand_or_jump()
                     else
                       fallback()
                     end
                   end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<S-Tab>" = {
            action = ''
                   function(fallback)
              local luasnip = require("luasnip")
                     if cmp.visible() then
                       cmp.select_prev_item()
                     elseif luasnip.jumpable(-1) then
                       luasnip.jump(-1)
                     else
                       fallback()
                     end
                   end
            '';
            modes = [
              "i"
              "s"
            ];
          };
        };
      };
      dap = {
        enable = true;
        extensions = {
          dap-ui.enable = true;
          dap-python = {
            enable = true;
            adapterPythonPath = "${pkgs.python3.withPackages (ps: with ps; [debugpy])}/bin/python3";
          };
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      vim-fetch
      telescope-gitsigns
    ];
  };
}
