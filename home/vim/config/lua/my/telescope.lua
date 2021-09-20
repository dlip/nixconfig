local actions = require'telescope.actions'
local trouble = require'trouble.providers.telescope'

local telescope = require'telescope'

telescope.load_extension'dap'
telescope.setup {
  defaults = {
    mappings = {
      i = { ['<c-t>'] = trouble.open_with_trouble },
      n = { ['<c-t>'] = trouble.open_with_trouble },
    },
  },
}
