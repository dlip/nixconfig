local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}
local cmd = vim.cmd

-- clear search highlighting
map('n', '<esc>', ':nohl<CR>', default_opts)

-- move windows using arrows
map('', '<C-up>', '<C-w>k', default_opts)
map('', '<C-down>', '<C-w>j', default_opts)
map('', '<C-left>', '<C-w>h', default_opts)
map('', '<C-right>', '<C-w>l', default_opts)
map('', '<C-S-up>', '<C-w>K', default_opts)
map('', '<C-S-down>', '<C-w>J', default_opts)
map('', '<C-S-left>', '<C-w>H', default_opts)
map('', '<C-S-right>', '<C-w>L', default_opts)
map('t', '<C-up>', '<C-\\><C-n><C-w>k', default_opts)
map('t', '<C-down>', '<C-\\><C-n><C-w>j', default_opts)
map('t', '<C-left>', '<C-\\><C-n><C-w>h', default_opts)
map('t', '<C-right>', '<C-\\><C-n><C-w>l', default_opts)
map('t', '<C-S-up>', '<C-\\><C-n><C-w>K', default_opts)
map('t', '<C-S-down>', '<C-\\><C-n><C-w>J', default_opts)
map('t', '<C-S-left>', '<C-\\><C-n><C-w>H', default_opts)
map('t', '<C-S-right>', '<C-\\><C-n><C-w>L', default_opts)

----------------------------------------------------------
-- Colemak remapings:
----------------------------------------------------------

-- arrows
map('', 'u', 'k', default_opts)
map('', 'e', 'j', default_opts)
map('', 'n', 'h', default_opts)
map('', 'i', 'l', default_opts)
map('', 'U', '5k', default_opts)
map('', 'E', '5j', default_opts)

-- Word left/right
map('', 'l', 'b', default_opts)
map('', 'y', 'w', default_opts)
map('', '<C-l>', 'B', default_opts)
map('', '<C-y>', 'W', default_opts)

-- End of word left/right
map('n', 'N', 'ge', default_opts)
map('x', 'N', 'ge', default_opts)
map('o', 'N', 'ge', default_opts)
map('n', 'I', 'e', default_opts)
map('x', 'I', 'e', default_opts)
map('o', 'I', 'e', default_opts)

-- Beginning/end of line
map('', 'L', '^', default_opts)
map('', 'Y', 'g_', default_opts)

-- Copy/paste
map('n', 'c', 'y', default_opts)
map('x', 'c', 'y', default_opts)
map('n', 'v', 'p', default_opts)
map('x', 'v', 'p', default_opts)
map('n', 'C', 'yg_', default_opts)
map('x', 'C', 'y', default_opts)
map('n', 'V', 'P', default_opts)
map('x', 'V', 'P', default_opts)
map('n', 'cc', 'yy', default_opts)

-- Undo/redo
map('n', 'z', 'u', default_opts)
map('x', 'z', ':<C-u>undo<CR>', default_opts)
map('n', 'Z', '<C-r>', default_opts)
map('x', 'Z', ':<C-u>redo<CR>', default_opts)
map('n', 'gz', 'U', default_opts)
map('x', 'gz', 'U<C-u>undo<CR>', default_opts)

-- PageUp/PageDown
--     nnoremap <silent> <expr> j (winheight(0)-1) . "\<C-u>"
--     nnoremap <silent> <expr> h (winheight(0)-1) . "\<C-d>"
--     xnoremap <silent> <expr> j (winheight(0)-1) . "\<C-u>"
--     xnoremap <silent> <expr> h (winheight(0)-1) . "\<C-d>"
--     nnoremap <silent> <expr> <PageUp> (winheight(0)-1) . "\<C-u>"
--     nnoremap <silent> <expr> <PageDown> (winheight(0)-1) . "\<C-d>"
--     vnoremap <silent> <expr> <PageUp> (winheight(0)-1) . "\<C-u>"
--     vnoremap <silent> <expr> <PageDown> (winheight(0)-1) . "\<C-d>"
--     vnoremap <silent> <expr> <S-PageUp> (winheight(0)-1) . "\<C-u>"
--     vnoremap <silent> <expr> <S-PageDown> (winheight(0)-1) . "\<C-d>"

-- Jumplist navigation
map('n', '<C-u>', '<C-i>', default_opts)
map('n', '<C-e>', '<C-o>', default_opts)
map('v', '<C-u>', '<C-i>', default_opts)
map('v', '<C-e>', '<C-o>', default_opts)

-- Text objects
-- diw is drw. daw is now dtw.
map('o', 'r', 'i', default_opts)
map('v', 'r', 'i', default_opts)
map('o', 't', 'a', default_opts)
map('v', 't', 'a', default_opts)
-- Move visual replace from 'r' to 'R'
map('o', 'R', 'r', default_opts)
map('v', 'R', 'r', default_opts)
-- Quicker word change
map('o', '<space>', 'iw', default_opts)

-- Folds
map('n', 'b', 'z', default_opts)
map('x', 'b', 'z', default_opts)
map('n', 'bb', 'zb', default_opts)
map('x', 'bb', 'zb', default_opts)
map('n', 'bu', 'zk', default_opts)
map('x', 'bu', 'zk', default_opts)
map('n', 'be', 'zj', default_opts)
map('x', 'be', 'zj', default_opts)

-- inSert/append (T)
map('n', 's', 'i', default_opts)
map('n', 'S', 'I', default_opts)
map('n', 't', 'a', default_opts)
map('n', 'T', 'A', default_opts)

-- Change
map('n', 'w', 'c', default_opts)
map('x', 'w', 'c', default_opts)
map('n', 'W', 'C', default_opts)
map('x', 'W', 'C', default_opts)
map('n', 'ww', 'cc', default_opts)

-- Visual mode
map('n', 'a', 'v', default_opts)
map('x', 'a', 'v', default_opts)
map('n', 'A', 'V', default_opts)
map('x', 'A', 'V', default_opts)

-- Insert in Visual mode
map('v', 'S', 'I', default_opts)

-- Search
map('', 'k', 'n', default_opts)
map('', 'K', 'N', default_opts)

-- 'til
-- Breaks diffput
map('', 'p', 't', default_opts)
map('', 'P', 'T', default_opts)

-- Fix diffput (t for 'transfer')
map('n', 'dt', 'dp', default_opts)

-- Macros (replay the macro recorded by qq)
map('n', 'Q', '@q', default_opts)

-- Cursor to bottom of screen
-- H and M haven't been remapped, only L needs to be mapped
map('n', 'B', 'L', default_opts)
map('v', 'B', 'L', default_opts)

-- Misc overridden keys must be prefixed with g
map('n', 'gS', 'S', default_opts)
map('x', 'gS', 'S', default_opts)
map('n', 'gX', 'X', default_opts)
map('x', 'gX', 'X', default_opts)
map('n', 'gU', 'U', default_opts)
map('x', 'gU', 'U', default_opts)
map('n', 'gQ', 'Q', default_opts)
map('x', 'gQ', 'Q', default_opts)
map('n', 'gK', 'K', default_opts)
map('x', 'gK', 'K', default_opts)
-- extra alias
map('n', 'gh', 'K', default_opts)
map('x', 'gh', 'K', default_opts)

-- Move lines
map('n', '<A-e>', ':m .+1<CR>==', default_opts)
map('n', '<A-u>', ':m .-2<CR>==', default_opts)
map('i', '<A-e>', '<Esc>:m .+1<CR>==gi', default_opts)
map('i', '<A-u>', '<Esc>:m .-2<CR>==gi', default_opts)
map('v', '<A-e>', ':m \'>+1<CR>gv=gv', default_opts)
map('v', '<A-u>', ':m \'<-2<CR>gv=gv', default_opts)

-- Navigate back/forward
map('', '<A-n>', '<C-o>', default_opts)
map('', '<A-i>', '<C-i>', default_opts)
