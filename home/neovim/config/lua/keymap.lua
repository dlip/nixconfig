local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}
local cmd = vim.cmd 	-- using cmd to execute vim script

-- clear search highlighting
map('n', '<esc>', ':nohl<CR>', default_opts)

-- Escape sequence in terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', default_opts)

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
map('', 'f', 'k', default_opts)
map('', 's', 'j', default_opts)
map('', 'r', 'h', default_opts)
map('', 't', 'l', default_opts)
map('', 'F', '<C-u>', default_opts)
map('', 'S', '<C-d>', default_opts)

-- Word left/right
map('', 'w', 'b', default_opts)
map('', 'p', 'w', default_opts)
map('', 'W', 'B', default_opts)
map('', 'P', 'W', default_opts)

-- Beginning/end of line
map('', 'R', '^', default_opts)
map('', 'T', '$', default_opts)
map('v', 'T', 'g_', default_opts)

-- Copy/paste
map('n', 'c', 'y', default_opts)
map('x', 'c', 'y', default_opts)
map('n', 'd', 'p', default_opts)
map('x', 'd', 'pgvy', default_opts) -- paste without yanking
map('n', 'C', 'yg_', default_opts)
map('x', 'C', 'y', default_opts)
map('n', 'D', 'P', default_opts)
map('x', 'D', 'P', default_opts)
map('n', 'cc', 'yy', default_opts)

-- Undo/redo
map('n', 'z', 'u', default_opts)
map('x', 'z', ':<C-u>undo<CR>', default_opts)
map('n', 'Z', '<C-r>', default_opts)
map('x', 'Z', ':<C-u>redo<CR>', default_opts)
map('n', 'gz', 'U', default_opts)
map('x', 'gz', 'U<C-u>undo<CR>', default_opts)

-- Visual mode
map('n', 'h', 'v', default_opts)
map('n', 'H', 'V', default_opts)

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
map('n', '<C-f>', '<C-i>', default_opts)
map('n', '<C-s>', '<C-o>', default_opts)
map('v', '<C-f>', '<C-i>', default_opts)
map('v', '<C-s>', '<C-o>', default_opts)

-- Quicker word change
map('n', 'u<space>', 'ciw', default_opts)

-- Folds
map('n', 'j', 'z', default_opts)
map('x', 'j', 'z', default_opts)

-- Change
map('n', 'u', 'c', default_opts)
map('x', 'u', 'c', default_opts)
map('n', 'U', 'C', default_opts)
map('x', 'U', 'C', default_opts)
map('n', 'uu', 'cc', default_opts)

-- Replace
map('n', 'y', 'r', default_opts)
map('x', 'y', 'r', default_opts)
map('n', 'Y', 'R', default_opts)
map('x', 'Y', 'R', default_opts)

-- Delete
map('n', 'x', 'd', default_opts)
map('v', 'x', 'd', default_opts)
map('n', 'X', 'D', default_opts)
map('v', 'X', 'D', default_opts)
map('n', 'xx', 'dd', default_opts)

-- 'til
map('', 'l', 't', default_opts)
map('', 'L', 'T', default_opts)

-- Macros (replay the macro recorded by qq)
map('n', 'Q', '@q', default_opts)

-- Cursor to bottom of screen
map('n', '<C-s>', 'L', default_opts)
map('v', '<C-s>', 'L', default_opts)

-- Cursor to top of screen
map('n', '<C-f>', 'H', default_opts)
map('v', '<C-f>', 'H', default_opts)

-- Go to mark / switch case
map('n', 'b', '`', default_opts)
map('v', 'b', '`', default_opts)
map('n', 'B', '~', default_opts)
map('v', 'B', '~', default_opts)

-- Move lines
map('n', '<A-f>', ':m .-2<CR>==', default_opts)
map('n', '<A-s>', ':m .+1<CR>==', default_opts)
map('i', '<A-f>', '<Esc>:m .-2<CR>==gi', default_opts)
map('i', '<A-s>', '<Esc>:m .+1<CR>==gi', default_opts)
map('v', '<A-f>', ':m \'<-2<CR>gv=gv', default_opts)
map('v', '<A-s>', ':m \'>+1<CR>gv=gv', default_opts)

-- Navigate back/forward
map('', '<A-r>', '<C-o>', default_opts)
map('', '<A-t>', '<C-i>', default_opts)


-- Enable enter and backspace in normal mode
map('n', '<CR>', 'o<Space><Backspace><Esc>', default_opts)
cmd[[
au FileType qf nmap <buffer> <CR> <CR>
]]
map('n', '<Backspace>', 'X', default_opts)

-- Enable repeating change of selection
map('v', 'gu', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>Ncgn', default_opts)
map('v', 'gU', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>NcgN', default_opts)

-- Paste in insert mode
map('i', '<C-v>', '<C-r>"', default_opts)

-- Plugins
cmd[[
" Easymotion
map k <Plug>(easymotion-sl)
map K <Plug>(easymotion-bd-f)
" Close quickfix by q
au FileType qf nmap <buffer><silent> q :ccl<CR>
]]
