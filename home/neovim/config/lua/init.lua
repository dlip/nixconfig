require 'env'
require 'keymap'
require 'settings'
require 'plugins/autosave'
require 'plugins/barbar'
require 'plugins/cmp'
require 'plugins/comment'
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
require 'plugins/neorg' -- requires treesitter
require 'plugins/whichkey'

-- disable some builtin vim plugins
local disabled_built_ins = {
   "2html_plugin",
   "getscript",
   "getscriptPlugin",
   "gzip",
   "logipat",
   "netrw",
   "netrwPlugin",
   "netrwSettings",
   "netrwFileHandlers",
   "matchit",
   "tar",
   "tarPlugin",
   "rrhelper",
   "spellfile_plugin",
   "vimball",
   "vimballPlugin",
   "zip",
   "zipPlugin",
}

for _, plugin in pairs(disabled_built_ins) do
   vim.g["loaded_" .. plugin] = 1
end

