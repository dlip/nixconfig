local map = vim.api.nvim_set_keymap
local cmd = vim.cmd 	-- using cmd to execute vim script

local keymaps = {
  -- clear search highlighting
  {'n', '<esc>', '<cmd>nohl<CR>'},

  -- Escape sequence in terminal
  {'t', '<Esc><Esc>', '<C-\\><C-n>'},

  -- move windows using arrows
  {'nxo', '<C-Up>', '<cmd>TmuxNavigateUp<CR>'},
  {'nxo', '<C-Down>', '<cmd>TmuxNavigateDown<CR>'},
  {'nxo', '<C-Left>', '<cmd>TmuxNavigateLeft<CR>'},
  {'nxo', '<C-Right>', '<cmd>TmuxNavigateRight<CR>'},
  {'nxo', '<C-S-up>', '<C-w>K'},
  {'nxo', '<C-S-down>', '<C-w>J'},
  {'nxo', '<C-S-left>', '<C-w>H'},
  {'nxo', '<C-S-right>', '<C-w>L'},

  -- Bufferline
  {'nxo', '<M-w>', '<cmd>BufferLineCyclePrev<CR>'},
  {'nxo', '<M-p>', '<cmd>BufferLineCycleNext<CR>'},
  {'nxo', '<M-W>', '<cmd>BufferLineMovePrev<CR>'},
  {'nxo', '<M-P>', '<cmd>BufferLineMoveNext<CR>'},

  -- arrows
  {'nxo', 'f', 'k'},
  {'nxo', 's', 'j'},
  {'nxo', 'r', 'h'},
  {'nxo', 't', 'l'},

  -- Word left/right
  {'nxo', 'w', 'b'},
  {'nxo', 'p', 'w'},
  {'nxo', 'W', 'B'},
  {'nxo', 'P', 'W'},

  -- Beginning/end of line
  {'nxo', 'R', '^'},
  {'no', 'T', '$'},
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
  {'x', 'z', '<cmd><C-u>undo<CR>'},
  {'n', 'Z', '<C-r>'},
  {'x', 'Z', '<cmd><C-u>redo<CR>'},
  {'n', 'gz', 'U'},
  {'x', 'gz', 'U<C-u>undo<CR>'},

  -- Visual mode
  {'n', 'h', 'v'},
  {'n', 'H', 'V'},

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

  -- Go to mark / switch case
  {'nx', 'b', '`'},
  {'nx', 'B', '~'},

  -- Move lines
  {'n', '<A-f>', '<cmd>m .-2<CR>=='},
  {'n', '<A-s>', '<cmd>m .+1<CR>=='},
  {'i', '<A-f>', '<Esc>:m .-2<CR>==gi'},
  {'i', '<A-s>', '<Esc>:m .+1<CR>==gi'},
  {'x', '<A-f>', '<cmd>m \'<-2<CR>gv=gv'},
  {'x', '<A-s>', '<cmd>m \'>+1<CR>gv=gv'},

  -- Navigate back/forward in jumplist
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
  
  -- Hop
  {'nxo', 'k', '<cmd>HopChar1AC<CR>'},
  {'nxo', 'K', '<cmd>HopChar1BC<CR>'},
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


