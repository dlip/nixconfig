local map = vim.api.nvim_set_keymap
local cmd = vim.cmd 	-- using cmd to execute vim script

local keymaps = {
  -- clear search highlighting
  {'n', '<esc>', ':nohl<CR>'},

  -- Escape sequence in terminal
  {'t', '<Esc><Esc>', '<C-\\><C-n>'},

  -- move windows using arrows
  {'nvo', '<C-up>', '<C-w>k'},
  {'nvo', '<C-down>', '<C-w>j'},
  {'nvo', '<C-left>', '<C-w>h'},
  {'nvo', '<C-right>', '<C-w>l'},
  {'nvo', '<C-S-up>', '<C-w>K'},
  {'nvo', '<C-S-down>', '<C-w>J'},
  {'nvo', '<C-S-left>', '<C-w>H'},
  {'nvo', '<C-S-right>', '<C-w>L'},
  -- {'nvo', '<C-S-right>', '<C-w>y<C-w>l<C-w>pp'},
  -- {'nvo', '<C-S-right>', '<C-w>l:e <C-r>#<CR><C-w>h:bp<CR>'},
  {'t', '<C-up>', '<C-\\><C-n><C-w>k'},
  {'t', '<C-down>', '<C-\\><C-n><C-w>j'},
  {'t', '<C-left>', '<C-\\><C-n><C-w>h'},
  {'t', '<C-right>', '<C-\\><C-n><C-w>l'},
  {'t', '<C-S-up>', '<C-\\><C-n><C-w>K'},
  {'t', '<C-S-down>', '<C-\\><C-n><C-w>J'},
  {'t', '<C-S-left>', '<C-\\><C-n><C-w>H'},
  {'t', '<C-S-right>', '<C-\\><C-n><C-w>L'},

  -- arrows
  {'nvo', 'f', 'k'},
  {'nvo', 's', 'j'},
  {'nvo', 'r', 'h'},
  {'nvo', 't', 'l'},
  {'nvo', 'F', '<C-u>'},
  {'nvo', 'S', '<C-d>'},

  -- Word left/right
  {'nvo', 'w', 'b'},
  {'nvo', 'p', 'w'},
  {'nvo', 'W', 'B'},
  {'nvo', 'P', 'W'},

  -- Beginning/end of line
  {'nvo', 'R', '^'},
  {'nvo', 'T', '$'},
  {'v', 'T', 'g_'},

  -- Copy/paste
  {'n', 'c', 'y'},
  {'x', 'c', 'y'},
  {'n', 'd', 'p'},
  {'x', 'd', 'pgvy'},
  {'n', 'C', 'yg_'},
  {'x', 'C', 'y'},
  {'n', 'D', 'P'},
  {'x', 'D', 'P'},
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
  {'n', '<C-f>', '<C-i>'},
  {'n', '<C-s>', '<C-o>'},
  {'v', '<C-f>', '<C-i>'},
  {'v', '<C-s>', '<C-o>'},

  -- Quicker word change
  {'n', 'u<space>', 'ciw'},

  -- Folds
  {'n', 'j', 'z'},
  {'x', 'j', 'z'},

  -- Change
  {'n', 'u', 'c'},
  {'x', 'u', 'c'},
  {'n', 'U', 'C'},
  {'x', 'U', 'C'},
  {'n', 'uu', 'cc'},

  -- Replace
  {'n', 'y', 'r'},
  {'x', 'y', 'r'},
  {'n', 'Y', 'R'},
  {'x', 'Y', 'R'},

  -- Delete
  {'n', 'x', 'd'},
  {'v', 'x', 'd'},
  {'n', 'X', 'D'},
  {'v', 'X', 'D'},
  {'n', 'xx', 'dd'},

  -- 'til
  {'nvo', 'l', 't'},
  {'nvo', 'L', 'T'},

  -- Macros (replay the macro recorded by qq)
  {'n', 'Q', '@q'},

  -- Cursor to bottom of screen
  {'n', '<C-s>', 'L'},
  {'v', '<C-s>', 'L'},

  -- Cursor to top of screen
  {'n', '<C-f>', 'H'},
  {'v', '<C-f>', 'H'},

  -- Go to mark / switch case
  {'n', 'b', '`'},
  {'v', 'b', '`'},
  {'n', 'B', '~'},
  {'v', 'B', '~'},

  -- Move lines
  {'n', '<A-f>', ':m .-2<CR>=='},
  {'n', '<A-s>', ':m .+1<CR>=='},
  {'i', '<A-f>', '<Esc>:m .-2<CR>==gi'},
  {'i', '<A-s>', '<Esc>:m .+1<CR>==gi'},
  {'v', '<A-f>', ':m \'<-2<CR>gv=gv'},
  {'v', '<A-s>', ':m \'>+1<CR>gv=gv'},

  -- Navigate back/forward
  {'nvo', '<A-r>', '<C-o>'},
  {'nvo', '<A-t>', '<C-i>'},


  -- Enable enter and backspace in normal mode
  {'n', '<CR>', 'o<Space><Backspace><Esc>'},
  {'n', '<Backspace>', 'X'},

  -- Enable repeating change of selection
  {'v', 'gu', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>Ncgn'},
  {'v', 'gU', 'y/\\V<C-R>=escape(@",\'/\\\')<CR><CR>NcgN'},

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
