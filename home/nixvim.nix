{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

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
      splitright = true; # vertical split to the right
      splitbelow = true; # horizontal split to the bottom
      incsearch = true; # Incremental search: show match for partly typed search command
      ignorecase = true; # When the search query is lower-case, match both lower and upper-case
      smartcase = true; # Override the 'ignorecase' option if the search pattern contains upper
      expandtab = true; # use spaces instead of tabs
      shiftwidth = 2; # shift 2 spaces when tab
      tabstop = 2; # 1 tab == 2 spaces
      smartindent = true; # autoindent new lines
      wrap = false; # Disable line wrapping
      scrolloff = 10; # keep cursor away from top/bottom edge of the screen
      sidescrolloff = 20; # keep cursor away from right edge of the screen
      foldlevel = 99; # unfold everything by default
      cursorline = true; # highlight current line
      lazyredraw = true; # faster scrolling
      list = true; # show hidden characters
      exrc = true; # Loads project specific settings from .exrc, .nvimrc and .nvim.lua files
      hidden = true; # enable background buffers
      history = 100; # remember n lines in history
      synmaxcol = 240; # max column for syntax highlight
      # what hidden characters to show
      listchars = {
        trail = "•"; # trailing space
        tab = "»\ "; # tabs
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
    files = {
      "ftplugin/tsv.lua" = {
        options = {
          expandtab = false;
        };
      };
      "ftplugin/go.lua" = {
        options = {
          expandtab = false;
        };
      };
      "ftplugin/markdown.lua" = {
        options = {
          wrap = true;
        };
      };
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
        key = "<leader>D";
        action = "<cmd>TroubleToggle<CR>";
        options = {
          desc = "Trouble Toggle";
          silent = true;
        };
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
        key = "<leader>b";
        action = "<cmd>Telescope buffers sort_last_used=true ignore_current_buffer=true<CR>";
        options = {
          desc = "Frequently Used Files";
          silent = true;
        };
      }
      {
        mode = "x";
        key = "<leader>f";
        action = "<cmd>Telescope grep_string<CR>";
        options = {
          desc = "Grep selection";
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
          desc = "Yank relative filename with line";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>Y";
        action = "<cmd>let @+=expand('%:p')<CR>";
        options = {
          desc = "Yank absolute filename";
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
        key = "<leader>gh";
        action = "<cmd>Telescope git_bcommits<Cr>";
        options = {
          desc = "Buffer history";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gl";
        action = "<cmd>Telescope git_commits<Cr>";
        options = {
          desc = "Stage hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>Telescope git_status<Cr>";
        options = {
          desc = "Stage hunk";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ga";
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
        key = "<leader>gp";
        action = "<cmd>Gitsigns preview_hunk<Cr>";
        options = {
          desc = "Preview Hunk";
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
      {
        mode = "n";
        key = "<leader>l";
        action = "<cmd>LazyGit<CR>";
        options = {
          desc = "LazyGit";
          silent = true;
        };
      }
      # debug
      {
        mode = "n";
        key = "<leader>ec";
        action = "<cmd>DapContinue<CR>";
        options = {
          desc = "Continue";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ej";
        action = "<cmd>DapLoadLaunchJSON<CR>";
        options = {
          desc = "Load launch.json";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>eq";
        action = "<cmd>DapRestartFrame<CR>";
        options = {
          desc = "Continue";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ev";
        action = "<cmd>DapSetLogLevel<CR>";
        options = {
          desc = "Set Log Level";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>el";
        action = "<cmd>DapShowLog<CR>";
        options = {
          desc = "Show Log";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ei";
        action = "<cmd>DapStepInto<CR>";
        options = {
          desc = "Step Into";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>eo";
        action = "<cmd>DapStepOut<CR>";
        options = {
          desc = "Step Out";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>es";
        action = "<cmd>DapStepOver<CR>";
        options = {
          desc = "Step Over";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ex";
        action = "<cmd>DapTerminate<CR>";
        options = {
          desc = "Terminate";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>eb";
        action = "<cmd>DapToggleBreakpoint<CR>";
        options = {
          desc = "Toggle Breakpoint";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>er";
        action = "<cmd>DapToggleRepl<CR>";
        options = {
          desc = "Toggle Repl";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>ed";
        action = "function() require('dapui').toggle() end";
        lua = true;
        options = {
          desc = "Toggle UI";
          silent = true;
        };
      }
    ];
    extraConfigLua = ''
      local dap, dapui = require("dap"), require("dapui")
      require('dap.ext.vscode').load_launchjs()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Run this file",
          start_neovim = {},
        },
        -- {
        --   type = "nlua",
        --   request = "attach",
        --   name = "Attach to running Neovim instance (port = 8086)",
        --   port = 8086,
        -- },
      }

      dap.adapters.nlua = function(callback, conf)
        local adapter = {
          type = "server",
          host = conf.host or "127.0.0.1",
          port = conf.port or 8086,
        }
        if conf.start_neovim then
          local dap_run = dap.run
          dap.run = function(c)
            adapter.port = c.port
            adapter.host = c.host
          end
          require("osv").run_this()
          dap.run = dap_run
        end
        callback(adapter)
      end

      require'nu'.setup{}
      require'lspconfig'.nushell.setup{}
    '';
    plugins = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
      which-key = {
        enable = true;
        registrations = {
          "<leader>e" = "Debug";
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
          "<leader>d" = {
            action = "diagnostics";
            desc = "Diagnostics";
          };
          "<leader>f" = {
            action = "live_grep";
            desc = "Grep";
          };
          "<leader>m" = {
            action = "man_pages";
            desc = "Search Manual";
          };
          "<leader>p" = {
            action = "find_files";
            desc = "Find Files";
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
          pickers = {
            find_files = {
              hidden = true;
              file_ignore_patterns = ["%.git/.*"];
            };
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
          # pyright.enable = true;
          pylsp = {
            enable = true;
            # settings.plugins = {
            #   jedi_definition = {
            #     enabled = true;
            #   };
            # };
          };
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
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
            "<leader>k" = {
              action = "hover";
              desc = "Hover";
            };
          };
        };
      };

      lsp-format.enable = true;
      trouble.enable = true;
      nvim-autopairs.enable = true;
      leap.enable = true;
      indent-blankline = {
        enable = true;
        scope.enabled = false;
      };

      treesitter = {
        enable = true;
        nixvimInjections = true;
        grammarPackages = with pkgs.tree-sitter-grammars;
          [
            tree-sitter-nu
          ]
          ++ builtins.attrValues (pkgs.lib.filterAttrs (k: v: pkgs.lib.hasPrefix "tree-sitter" k) pkgs.vimPlugins.nvim-treesitter.builtGrammars);
        indent = true;
        folding = true;
      };
      treesitter-context.enable = true;

      none-ls = {
        enable = true;
        enableLspFormat = true;
        sources = {
          formatting = {
            alejandra.enable = true;
            black.enable = true;
            eslint.enable = true;
            gofmt.enable = true;
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
        enable = false;

        #enableTelescope = true;
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
                local luasnip = require("luasnip")
                if cmp.visible() then
                  if not cmp.get_selected_entry() then
                    vim.defer_fn(function() vim.cmd('stopinsert') end, 1)
                  end
                  cmp.abort()
                else
                  if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
                    luasnip.unlink_current()
                  end
                  fallback()
                end
              end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<Up>" = {
            action = ''
              function(fallback)
                local luasnip = require("luasnip")
                if cmp.get_selected_entry() then
                  cmp.scroll_docs(-4)
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  if cmp.visible() then
                    cmp.abort()
                  end
                  if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
                    luasnip.unlink_current()
                  end
                  fallback()
                end
              end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<Down>" = {
            action = ''
              function(fallback)
                local luasnip = require("luasnip")
                if cmp.get_selected_entry() then
                  cmp.scroll_docs(4)
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  if cmp.visible() then
                    cmp.abort()
                  end
                  if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
                    luasnip.unlink_current()
                  end
                  fallback()
                end
              end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<CR>" = {
            action = ''
              function(fallback)
                local luasnip = require("luasnip")
                if cmp.get_selected_entry() then
                  cmp.confirm({ select = false })
                elseif luasnip.expandable() then
                  luasnip.expand()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  if cmp.visible() then
                    cmp.abort()
                  end
                  if luasnip.session.current_nodes[vim.api.nvim_get_current_buf()] then
                    luasnip.unlink_current()
                  end
                  fallback()
                end
              end
            '';
            modes = [
              "i"
              "s"
            ];
          };
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
        };
      };
      dap = {
        enable = true;
        extensions = {
          dap-ui.enable = true;
          dap-python.enable = true;
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      lazygit-nvim
      nu
      one-small-step-for-vimkind
      telescope-gitsigns
      vim-fetch
    ];
  };
}
