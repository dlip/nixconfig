-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local g = vim.g                 -- global variables
local opt = vim.opt             -- global/buffer/windows-scoped options

-----------------------------------------------------------
-- General
-----------------------------------------------------------
g.mapleader = ' '             -- change leader to a space
g.maplocalleader = ','        -- change local leader to a comma
opt.mouse = 'a'               -- enable mouse support
opt.clipboard = 'unnamedplus' -- copy/paste to system clipboard
opt.swapfile = false          -- don't use swapfile
opt.backup = false            -- don't create backups
opt.undofile = true           -- enable undofile for persistent undo
opt.undodir = vim.fn.expand('~/.config/nvim/undo') -- set undofile dir
opt.shadafile = vim.fn.expand('~/.config/nvim/viminfo') -- set shadafile dir
opt.timeoutlen = 500          -- timeout for key sequences

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true             -- show line number
opt.relativenumber = true     -- show relative line numbers
opt.showmatch = true          -- highlight matching parenthesis
-- opt.foldmethod = 'expr'       -- enable folding by expression
-- opt.foldexpr = 'nvim_treesitter#foldexpr()' -- enable treesitter folding
-- opt.colorcolumn = '80'        -- line lenght marker at 80 columns
opt.splitright = true         -- vertical split to the right
opt.splitbelow = true         -- horizontal split to the bottom
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
opt.wrap = false              -- No wrap
opt.scrolloff = 5             -- keep cursor away from top/bottom edge of the screen
opt.cursorline = true         -- highlight current line
opt.termguicolors = true      -- enable 24-bit RGB colors

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true         -- enable background buffers
opt.history = 100         -- remember n lines in history
opt.lazyredraw = true     -- faster scrolling
opt.synmaxcol = 240       -- max column for syntax highlight

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true      -- use spaces instead of tabs
opt.shiftwidth = 2        -- shift 4 spaces when tab
opt.tabstop = 4           -- 1 tab == 4 spaces
opt.smartindent = true    -- autoindent new lines

-----------------------------------------------------------
-- Autocompletion
-----------------------------------------------------------
opt.completeopt = 'menu,menuone,noselect' -- completion options
--opt.shortmess = 'c'   -- don't show completion messages

