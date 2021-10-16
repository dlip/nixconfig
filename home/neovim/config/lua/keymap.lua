local map = vim.api.nvim_set_keymap
local cmd = vim.cmd 	-- using cmd to execute vim script

local keymaps = {
  -- clear search highlighting
  {'n', '<esc>', ':nohl<CR>'},

  -- Escape sequence in terminal
  {'t', '<Esc><Esc>', '<C-\\><C-n>'},

  -- move windows using arrows
  {'nxo', '<C-up>', '<C-w>k'},
  {'nxo', '<C-down>', '<C-w>j'},
  {'nxo', '<C-left>', '<C-w>h'},
  {'nxo', '<C-right>', '<C-w>l'},
  {'nxo', '<C-S-up>', '<C-w>K'},
  {'nxo', '<C-S-down>', '<C-w>J'},
  {'nxo', '<C-S-left>', '<C-w>H'},
  {'nxo', '<C-S-right>', '<C-w>L'},
  {'t', '<C-up>', '<C-\\><C-n><C-w>k'},
  {'t', '<C-down>', '<C-\\><C-n><C-w>j'},
  {'t', '<C-left>', '<C-\\><C-n><C-w>h'},
  {'t', '<C-right>', '<C-\\><C-n><C-w>l'},
  {'t', '<C-S-up>', '<C-\\><C-n><C-w>K'},
  {'t', '<C-S-down>', '<C-\\><C-n><C-w>J'},
  {'t', '<C-S-left>', '<C-\\><C-n><C-w>H'},
  {'t', '<C-S-right>', '<C-\\><C-n><C-w>L'},

  -- arrows
  {'nxo', 'f', 'k'},
  {'nxo', 's', 'j'},
  {'nxo', 'r', 'h'},
  {'nxo', 't', 'l'},
  {'nxo', 'F', '<C-u>'},
  {'nxo', 'S', '<C-d>'},

  -- Word left/right
  {'nxo', 'w', 'b'},
  {'nxo', 'p', 'w'},
  {'nxo', 'W', 'B'},
  {'nxo', 'P', 'W'},

  -- Beginning/end of line
  {'nxo', 'R', '^'},
  {'nxo', 'T', '$'},
  {'x', 'T', 'g_'},

  -- Copy/paste
  {'nx', 'c', 'y'},
  {'n', 'd', 'p'},
  {'x', 'd', 'pgvy'},
  {'n', 'C', 'yg_'},
  {'x', 'C', 'y'},
  {'nx', 'D', 'P'},
  {'n', 'cc', 'yy'},

  -- Undo/redo
  {'n', 'z', 'u'},
  {'x', 'z', ':<C-u>undo<CR>'},
  {'n', 'Z', '<C-r>'},
  {'x', 'Z', ':<C-u>redo<CR>'},
  {'n', 'gz', 'U'},
  {'x', 'gz', 'U<C-u>undo<CR>'},

  -- Visual mode
  {'n', 'h', 'v'},
  {'n', 'H', 'V'},

  -- Jumplist navigation
  {'nx', '<C-f>', '<C-i>'},
  {'nx', '<C-s>', '<C-o>'},

  -- Quicker word change
  {'n', 'u<space>', 'ciw'},

  -- Folds
  {'nx', 'j', 'z'},

  -- Change
  {'nx', 'u', 'c'},
  {'nx', 'U', 'C'},
  {'n', 'uu', 'cc'},

  -- Replace
  {'nx', 'y', 'r'},
  {'nx', 'Y', 'R'},

  -- Delete
  {'nx', 'x', 'd'},
  {'nx', 'X', 'D'},
  {'n', 'xx', 'dd'},

  -- 'til
  {'nxo', 'l', 't'},
  {'nxo', 'L', 'T'},

  -- Macros (replay the macro recorded by qq)
  {'n', 'Q', '@q'},

  -- Cursor to bottom of screen
  {'nx', '<C-s>', 'L'},

  -- Cursor to top of screen
  {'nx', '<C-f>', 'H'},

  -- Go to mark / switch case
  {'nx', 'b', '`'},
  {'nx', 'B', '~'},

  -- Move lines
  {'n', '<A-f>', ':m .-2<CR>=='},
  {'n', '<A-s>', ':m .+1<CR>=='},
  {'i', '<A-f>', '<Esc>:m .-2<CR>==gi'},
  {'i', '<A-s>', '<Esc>:m .+1<CR>==gi'},
  {'x', '<A-f>', ':m \'<-2<CR>gv=gv'},
  {'x', '<A-s>', ':m \'>+1<CR>gv=gv'},

  -- Navigate back/forward
  {'nxo', '<A-r>', '<C-o>'},
  {'nxo', '<A-t>', '<C-i>'},


  -- Enable enter and backspace in normal mode
  {'n', '<CR>', 'o<Space><Backspace><Esc>'},
  {'n', '<Backspace>', 'X'},

  -- Enable repeating change of selection
  {'x', 'gu', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>Ncgn'},
  {'x', 'gU', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>NcgN'},

  -- Paste in insert mode
  {'i', '<C-v>', '<C-r>"'},
}

for i = 1, #keymaps do
  local opts = {noremap = true, silent = true}
  local keymap = keymaps[i]
  local modes = keymap[1]
  for j = 1, #modes do
    local mode = modes:sub(j,j)
    map(mode, keymap[2], keymap[3], opts)
  end
end

-- Restore enter functionality in quickfix window
cmd[[
au FileType qf nmap <buffer> <CR> <CR>
]]

-- Plugins
cmd[[
" Easymotion
map k <Plug>(easymotion-sl)
map K <Plug>(easymotion-bd-f)
" Close quickfix by q
au FileType qf nmap <buffer><silent> q :ccl<CR>
]]

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


