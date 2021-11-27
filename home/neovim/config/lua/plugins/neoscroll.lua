require("neoscroll").setup({
  mappings = {},
  hide_cursor = true, -- Hide cursor while scrolling
  stop_eof = true, -- Stop at <EOF> when scrolling downwards
  use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
  respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  easing_function = nil, -- Default easing function
  pre_hook = nil, -- Function to run before the scrolling animation starts
  post_hook = nil, -- Function to run after the scrolling animation ends
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
t["<S-Up>"] = { "scroll", { "-vim.wo.scroll", "true", "250" } }
t["<S-Down>"] = { "scroll", { "vim.wo.scroll", "true", "250" } }
-- t['<C-F>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '450'}}
-- t['<C-S>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '450'}}
-- t['<C-y>'] = {'scroll', {'-0.10', 'false', '100'}}
-- t['<C-e>'] = {'scroll', { '0.10', 'false', '100'}}
-- t['jt']    = {'zt', {'250'}}
-- t['jz']    = {'zz', {'250'}}
-- t['jb']    = {'zb', {'250'}}

require("neoscroll.config").set_mappings(t)
