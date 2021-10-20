require 'env'
require 'keymap'
require 'settings'
require 'plugins/autosave'
require 'plugins/barbar'
require 'plugins/cmp'
require 'plugins/dap'
require 'plugins/dashboard'
require 'plugins/diffview'
require 'plugins/gitsigns'
require 'plugins/hop'
require 'plugins/indent-blankline'
require 'plugins/lsp'
require 'plugins/lualine'
require 'plugins/luasnip'
require 'plugins/neogit'
require 'plugins/neoscroll'
require 'plugins/nvim-tree'
require 'plugins/telescope'
require 'plugins/trouble'
require 'plugins/treesitter'
require 'plugins/whichkey'

require'neuron'.setup {
    virtual_titles = true,
    mappings = true,
    run = nil, -- function to run when in neuron dir
    neuron_dir = "~/code/neuron", -- the directory of all of your notes, expanded by default (currently supports only one directory for notes, find a way to detect neuron.dhall to use any directory)
    leader = "gz", -- the leader key to for all mappings, remember with 'go zettel'
}
