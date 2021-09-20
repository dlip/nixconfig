require'my.options'

require'trouble'.setup()
require'gitsigns'.setup()
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      -- TODO
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  indent = {
    enable = false,
  },
}

require'my.completion'
require'my.dap'
require'my.lsp'
require'my.lualine'
require'my.telescope'
