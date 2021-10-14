-----------------------------------------------------------
-- Neovim API aliases
-----------------------------------------------------------
local cmd = vim.cmd             -- execute Vim commands
local exec = vim.api.nvim_exec  -- execute Vimscript
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
opt.timeoutlen = 500          -- timeout for key sequences

-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
opt.number = true             -- show line number
opt.relativenumber = true     -- show relative line numbers
opt.showmatch = true          -- highlight matching parenthesis
-- opt.foldmethod = 'expr'       -- enable folding by expression
-- opt.foldexpr = 'nvim_treesitter#foldexpr()' -- enable treesitter folding
opt.colorcolumn = '80'        -- line lenght marker at 80 columns
opt.splitright = true         -- vertical split to the right
opt.splitbelow = true         -- horizontal split to the bottom
opt.ignorecase = true         -- ignore case letters when search
opt.smartcase = true          -- ignore lowercase for the whole pattern
opt.wrap = false              -- No wrap
opt.scrolloff = 5             -- keep cursor away from top/bottom edge of the screen

-- remove whitespace on save
cmd [[au BufWritePre * :%s/\s\+$//e]]

-- highlight on yank
exec([[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
  augroup end
]], false)

-----------------------------------------------------------
-- Memory, CPU
-----------------------------------------------------------
opt.hidden = true         -- enable background buffers
opt.history = 100         -- remember n lines in history
opt.lazyredraw = true     -- faster scrolling
opt.synmaxcol = 240       -- max column for syntax highlight

-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
opt.termguicolors = true      -- enable 24-bit RGB colors
cmd [[colorscheme tokyonight]]

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------
opt.expandtab = true      -- use spaces instead of tabs
opt.shiftwidth = 4        -- shift 4 spaces when tab
opt.tabstop = 4           -- 1 tab == 4 spaces
opt.smartindent = true    -- autoindent new lines

-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remove line lenght marker for selected filetypes
cmd [[autocmd FileType text,markdown,xml,html,xhtml,javascript setlocal cc=0]]

-- 2 spaces for selected filetypes
cmd [[
  autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml setlocal shiftwidth=2 tabstop=2
]]

-- IndentLine
--g.indentLine_setColors = 0  -- set indentLine color
g.indentLine_char = '|'       -- set indentLine character

-- disable IndentLine for markdown files (avoid concealing)
cmd [[autocmd FileType markdown let g:indentLine_enabled=0]]

-----------------------------------------------------------
-- Autocompletion
-----------------------------------------------------------
opt.completeopt = 'menu,menuone,noselect' -- completion options
--opt.shortmess = 'c'   -- don't show completion messages

-----------------------------------------------------------
-- Terminal
-----------------------------------------------------------
-- open a terminal pane on the right using :Term
cmd [[command Term :botright split term://$SHELL]]

-- Terminal visual tweaks
--- enter insert mode when switching to terminal
--- close terminal buffer on process exit
cmd [[
    autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
    autocmd TermOpen * startinsert
    autocmd BufLeave term://* stopinsert
]]
