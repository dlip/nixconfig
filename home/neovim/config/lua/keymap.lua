local g = vim.g    -- global variables

local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}
local cmd = vim.cmd

-- clear search highlighting
map('n', '<esc>', ':nohl<CR>', default_opts)

-- move windows using arrows
map('', '<up>', '<C-w>k', default_opts)
map('', '<down>', '<C-w>j', default_opts)
map('', '<left>', '<C-w>h', default_opts)
map('', '<right>', '<C-w>l', default_opts)


----------------------------------------------------------
-- Colemak remapings:
----------------------------------------------------------

-- arrows
map('', 'u', 'k', default_opts)
map('', 'e', 'j', default_opts)
map('', 'n', 'h', default_opts)
map('', 'i', 'l', default_opts)

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

-- Window navigation
--     nnoremap <C-w>n <C-w>h|xnoremap <C-w>n <C-w>h|
--     nnoremap <C-w>u <C-w>k|xnoremap <C-w>u <C-w>k|
--     nnoremap <C-w>e <C-w>j|xnoremap <C-w>e <C-w>j|
--     nnoremap <C-w>i <C-w>l|xnoremap <C-w>i <C-w>l|
--     nnoremap <C-w>N <C-w>H|xnoremap <C-w>n <C-w>h|
--     nnoremap <C-w>U <C-w>K|xnoremap <C-w>u <C-w>k|
--     nnoremap <C-w>E <C-w>J|xnoremap <C-w>e <C-w>j|
--     nnoremap <C-w>I <C-w>L|xnoremap <C-w>i <C-w>l|
-- Disable spawning empty buffer
--     nnoremap <C-w><C-n> <nop>|xnoremap <C-w><C-n> <nop>|
