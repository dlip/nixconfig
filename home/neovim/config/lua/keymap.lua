local map = vim.api.nvim_set_keymap

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

  -- Barbar
  {'n', '<A-w>', '<cmd>BufferPrevious<CR>'},
  {'n', '<A-p>', '<cmd>BufferNext<CR>'},
  -- Re-order to previous/next
  {'n', '<A-W>', '<cmd>BufferMovePrevious<CR>'},
  {'n', '<A-P>', ' <cmd>BufferMoveNext<CR>'},
  -- Goto buffer in position...
  {'n', '<A-1>', '<cmd>BufferGoto 1<CR>'},
  {'n', '<A-2>', '<cmd>BufferGoto 2<CR>'},
  {'n', '<A-3>', '<cmd>BufferGoto 3<CR>'},
  {'n', '<A-4>', '<cmd>BufferGoto 4<CR>'},
  {'n', '<A-5>', '<cmd>BufferGoto 5<CR>'},
  {'n', '<A-6>', '<cmd>BufferGoto 6<CR>'},
  {'n', '<A-7>', '<cmd>BufferGoto 7<CR>'},
  {'n', '<A-8>', '<cmd>BufferGoto 8<CR>'},
  {'n', '<A-9>', '<cmd>BufferGoto 9<CR>'},
  {'n', '<A-0>', '<cmd>BufferLast<CR>'},
  {'n', '<A-x>', '<cmd>BufferClose<CR>'},
  {'n', '<A-a>', '<cmd>BufferPick<CR>'},

  -- Tabs
  {'n', '<A-c>', '<cmd>tabprevious<CR>'},
  {'n', '<A-d>', '<cmd>tabnext<CR>'},
  {'n', '<A-z>', '<cmd>tabclose<CR>'},
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


