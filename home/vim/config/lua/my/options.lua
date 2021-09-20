-- Helpers
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
  -- Concatenate lists with ','
  if type(value) == 'table' then
    value = table.concat(value, ',')
  end
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local indent = 2
opt('b', 'expandtab', true)         -- Use spaces instead of tabs
opt('b', 'shiftwidth', indent)      -- Size of an indent
opt('b', 'softtabstop', indent)     -- <Tab> does two spaces
opt('b', 'smartindent', true)       -- Insert indents automatically
opt('b', 'tabstop', 8)              -- Number of spaces tabs count for

opt('o', 'cursorline', true)
opt('o', 'completeopt', {'menuone', 'noselect'})
opt('o', 'diffopt', {
  'filler', -- Add vertical spaces to keep right and left aligned
  'iwhite', -- Ignore whitespace changes (focus on code changes)
})
opt('o', 'foldenable', true)   -- Enable folding
opt('o', 'foldlevel', 100)     -- Open all folds by default
opt('o', 'foldmethod', 'expr') -- Fold with tree-sitter
opt('o', 'foldexpr', 'nvim_treesitter#foldexpr()')
opt('o', 'formatoptions',
  'c' .. -- Format comments
  'r' .. -- Continue comments by default
  'o' .. -- Make comment when using o or O from comment line
  'q' .. -- Format comments with gq
  'n' .. -- Recognize numbered lists
  '2' .. -- Use indent from 2nd line of a paragraph
  'l' .. -- Don't break lines that are already long
  '1'    -- Break before 1-letter words
)
opt('o', 'gdefault', true)   -- g flag by default for search/replace
opt('o', 'hidden', true)     -- Buffers can go in the background
opt('o', 'ignorecase', true) -- Ignore case of searches
opt('o', 'smartcase', true)  -- ...unless something is uppercase in that search
opt('o', 'lazyredraw', true)
opt('o', 'listchars', {'tab:▸ ', 'eol:¬' ,'nbsp:•'})
opt('o', 'magic', true)         -- Extended regexes
opt('o', 'mouse', 'a')          -- Mouse support
opt('o', 'errorbells', false)   -- Disable error bells
opt('o', 'joinspaces', false)   -- Only insert single space after a '.', '?' and '!' with a join command
opt('o', 'showmode', false)     -- Already done by a plugin
opt('o', 'startofline', false)  -- Don't reset cursor to start of line when moving around
opt('w', 'number', true)        -- Show line numbers
opt('o', 'report', 0)           -- Show all changes
opt('o', 'scrolloff', 3)        -- Scroll offset
opt('o', 'sidescrolloff', 3)    -- same, but for the sides
opt('o', 'shell', '/bin/sh')    -- Shell for executing commands
opt('o', 'showtabline', 2)      -- Always show the tab line
opt('o', 'signcolumn', 'yes:1') -- Fixed width sign column
opt('o', 'splitbelow', true)    -- New windows goes below
opt('o', 'splitright', true)    -- New windows goes right
opt('o', 'suffixes', {          -- Files to ignore
  '.bak', '~', '.swp', '.swo', '.o', '.d', '.info', '.aux', '.log', '.dvi',
  '.pdf', '.bin', '.bbl', '.blg', '.brf', '.cb', '.dmg', '.exe', '.ind',
  '.idx', '.ilg', '.inx', '.out', '.toc', '.pyc', '.pyd', '.dll'
})
opt('o', 'termguicolors', true) -- True RGB colors (HDR10 when?)
opt('o', 'title', true)         -- Filename in window titlebar
opt('o', 'undofile', true)      -- Persistent undo
opt('o', 'shada', {
  '!',     -- Save and restore global variables
  "'9999", -- Number of remembered marks
  's512',  -- 512KiB of registers max
  'h',     -- Disable "hlsearch" on load
})

-- TODO: more wildmenu things
opt('o', 'wildchar', 9) -- <TAB> == 9
opt('o', 'wildmode', 'list:longest')

opt('o', 'winminheight', 0) -- Allow splits to be reduced to a single line
opt('o', 'wrapscan', true)  -- Searches wrap around end of file
