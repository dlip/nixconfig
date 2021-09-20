

g.mapleader = " "


vim.api.nvim_set_keymap("n", "<leader>",      [[:<c-u>WhichKey ','<CR>]],       { silent = true })
vim.api.nvim_set_keymap("n", "<space>",       [[:<c-u>WhichKey '<space>'<CR>]], { silent = true })
vim.api.nvim_set_keymap("n", "<localleader>", [[:<c-u>WhichKey "\\"<CR>]],      { silent = true })
vim.call('which_key#register', '<Space>', "g:which_key_space")
vim.call('which_key#register', ',',       "g:which_key_leader")
vim.call('which_key#register', '\\',      "g:which_key_localleader")
