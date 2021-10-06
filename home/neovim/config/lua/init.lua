require 'options'
require 'keymap'
require'trouble'.setup()
require'gitsigns'.setup()
require'nvim-treesitter.configs'.setup {
    highlight = {enable = true},
    incremental_selection = {
        enable = true,
        keymaps = {
            -- TODO
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm"
        }
    },
    indent = {enable = false}
}

require 'plugins/compe'
require 'plugins/dap'
require 'plugins/lsp'
require 'plugins/nvim-tree'
require 'plugins/lualine'
require 'plugins/telescope'
