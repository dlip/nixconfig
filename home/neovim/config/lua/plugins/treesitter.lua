require("nvim-treesitter.configs").setup({
  -- ensure_installed = {
  --   "bash",
  --   "c",
  --   "comment",
  --   "cpp",
  --   "css",
  --   "dot",
  --   "go",
  --   "haskell",
  --   "html",
  --   "http",
  --   "javascript",
  --   "jsdoc",
  --   "json",
  --   "hcl",
  --   "lua",
  --   "markdown",
  --   "nix",
  --   "python",
  --   "regex",
  --   "rust",
  --   "toml",
  --   "tsx",
  --   "typescript",
  --   "vim",
  --   "yaml",
  -- },
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gv",
      node_incremental = "v",
      scope_incremental = "grc",
      node_decremental = "V",
    },
  },
  indent = {
    enable = true,
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
    max_file_lines = nil, -- Do not enable for files with more than n lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- dlip: issue with vim complaining file exists
        -- Or you can define your own textobjects like this
        -- ["iF"] = {
        -- python = "(function_definition) @function",
        --   cpp = "(function_definition) @function",
        --   c = "(function_definition) @function",
        --   java = "(method_declaration) @function",
        -- },
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>l."] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>l,"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
    lsp_interop = {
      enable = true,
      border = "none",
      peek_definition_code = {
        ["<leader>lo"] = "@function.outer",
        ["<leader>lO"] = "@class.outer",
      },
    },
  },
})
