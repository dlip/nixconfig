local map = vim.api.nvim_set_keymap

local keymaps = {
  -- clear search highlighting
  { "n", "<esc>", "<cmd>nohl<CR>" },

  -- easier colon
  { "n", ";", ":", { noremap = true } },

  -- Escape sequence in terminal
  { "t", "<Esc><Esc>", "<C-\\><C-n>" },

  -- move windows using arrows
  { "nxo", "<C-Up>", "<cmd>TmuxNavigateUp<CR>" },
  { "nxo", "<C-Down>", "<cmd>TmuxNavigateDown<CR>" },
  { "nxo", "<C-Left>", "<cmd>TmuxNavigateLeft<CR>" },
  { "nxo", "<C-Right>", "<cmd>TmuxNavigateRight<CR>" },
  { "nxo", "<C-S-up>", "<C-w>K" },
  { "nxo", "<C-S-down>", "<C-w>J" },
  { "nxo", "<C-S-left>", "<C-w>H" },
  { "nxo", "<C-S-right>", "<C-w>L" },

  -- Don't include line feed
  { "x", "<End>", "g_" },
  { "n", "Y", "yg_" },

  -- Paste without yank
  { "x", "p", "pgvy" },

  -- Join with lowercase j
  { "n", "j", "J" },
  { "n", "J", "gJ" },

  -- Quicker word change
  { "n", "c<space>", "ciw" },
  { "x", "<space>", "iw" },

  -- Macros (replay the macro recorded by qq)
  { "n", "Q", "@q" },

  -- Move lines
  { "n", "<A-up>", "<cmd>m .-2<CR>==" },
  { "n", "<A-down>", "<cmd>m .+1<CR>==" },
  { "i", "<A-up>", "<Esc>:m .-2<CR>==gi" },
  { "i", "<A-down>", "<Esc>:m .+1<CR>==gi" },
  { "x", "<A-up>", "<cmd>m '<-2<CR>gv=gv" },
  { "x", "<A-down>", "<cmd>m '>+1<CR>gv=gv" },

  -- Enable enter and backspace in normal mode
  { "n", "<CR>", "o<Space><Backspace><Esc>" },
  { "n", "<Backspace>", "X" },

  -- Enable repeating change of selection
  { "x", "gl", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>Ncgn" },
  { "x", "gL", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>NcgN" },

  -- Paste in insert mode
  { "i", "<C-v>", '<C-r>"' },

  -- Hop
  { "nxo", "h", "<cmd>HopChar1AC<CR>" },
  { "nxo", "k", "<cmd>HopChar1BC<CR>" },
}

for i = 1, #keymaps do
  local keymap = keymaps[i]
  local opts = { noremap = true, silent = true }
  if keymap[4] then
    opts = keymap[4]
  end

  local modes = keymap[1]
  for j = 1, #modes do
    local mode = modes:sub(j, j)
    map(mode, keymap[2], keymap[3], opts)
  end
end
