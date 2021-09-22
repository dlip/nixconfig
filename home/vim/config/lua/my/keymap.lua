vim.api.nvim_set_keymap('n', '<Space>', '<NOP>', {})
-- :help just enough
vim.api.nvim_set_keymap('n', '<F1>', '<NOP>', {})
vim.api.nvim_set_keymap('i', '<F1>', '<NOP>', {})
vim.g.mapleader=" "
vim.g.maplocalleader=" ,"
vim.g.which_key_timeout = 100
local opt = {noremap=true, silent=true}

vim.api.nvim_set_keymap('n', 'Q', '<NOP>', opt)
-- windows navigation[
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', opt)
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', opt)
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', opt)
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', opt)
vim.api.nvim_set_keymap('n', '<leader>s', '<C-w>s', opt)
vim.api.nvim_set_keymap('n', '<leader>v', '<C-w>v', opt)

-- extended keyboard
-- Opens line below or above the current line
-- vim.api.nvim_set_keymap('i','<S-CR>','<C-O>o', {noremap=true})
-- vim.api.nvim_set_keymap('i','<C-CR>','<C-O>O', {noremap=true})

-- Terminal Navigation {{
-- vim.api.nvim_set_keymap('t', '<leader>h', [[<C-\><C-N><C-w>h]], opt)
-- vim.api.nvim_set_keymap('t', '<leader>j', [[<C-\><C-N><C-w>j]], opt)
-- vim.api.nvim_set_keymap('t', '<leader>k', [[<C-\><C-N><C-w>k]], opt)
-- vim.api.nvim_set_keymap('t', '<leader>l', [[<C-\><C-N><C-w>l]], opt)
vim.api.nvim_set_keymap('t', '<leader>s', [[<C-\><C-N><C-w>s]], opt)
vim.api.nvim_set_keymap('t', '<leader>v', [[<C-\><C-N><C-w>v]], opt)
vim.api.nvim_set_keymap('t', '<ESC>', [[<C-\><C-N>]], opt)
-- }}
-- Hate escape
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', opt)
vim.api.nvim_set_keymap('i', 'kj', '<ESC>', opt)
vim.api.nvim_set_keymap('i', 'kk', '<ESC>', opt)
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', opt)
-- Make arrow bit useful (for scrolling)
vim.api.nvim_set_keymap('n', '<Up>', '<C-y>', {})
vim.api.nvim_set_keymap('n', '<Down>', '<C-e>', {})

-- Command line mode (I don't care) {{{
vim.api.nvim_set_keymap('c', '<A-h>', '<Left>', {})
vim.api.nvim_set_keymap('c', '<A-l>', '<Right>', {})
--
vim.api.nvim_set_keymap('c', '<C-h>', '<Left>', {})
vim.api.nvim_set_keymap('c', '<C-l>', '<Right>', {})
vim.api.nvim_set_keymap('c', '<C-k>', '<Up>', {})
vim.api.nvim_set_keymap('c', '<C-j>', '<Down>', {})
vim.api.nvim_set_keymap('c', '<C-d>', '<C-u>', {})
vim.api.nvim_set_keymap('c', '<C-v>', '<C-r>+', {})
vim.api.nvim_set_keymap('c', '<C-p>', '<C-r>"', {})
--- }}}
-- Toggle Jump quickly between two files
vim.api.nvim_set_keymap('n', '<A-Tab>', '<C-^>', opt)

-- FIXME: Remove this
-- https://github.com/neovim/neovim/issues/12771
-- C-BS not behave as it should
vim.api.nvim_set_keymap('i', '<C-h>', '<C-W>', {})

-- Resizing:  {{{
-- FIXME:: If there's a conflict i need to change this
-- Horizontal
vim.api.nvim_set_keymap('n', '<A-=>', '<C-W>+', opt)
vim.api.nvim_set_keymap('n', '<A-->', '<C-W>-', opt)
-- Vertical
vim.api.nvim_set_keymap('n','<A-,>', '<C-W><',opt)
vim.api.nvim_set_keymap('n','<A-.>', '<C-W>>',opt)
vim.api.nvim_set_keymap('n', '<A-BS>', '<C-W>=', opt)

-- vim.api.nvim_set_keymap('n', '<Bslash>', ':', opt)
-- Indenting in visual block
vim.api.nvim_set_keymap('v', '<', '<gv', opt)
vim.api.nvim_set_keymap('v', '>', '>gv', opt)


-- Move selected line / block of text in visual
vim.api.nvim_set_keymap('x', 'K', ':move \'<-2<CR>gv-gv', opt)
vim.api.nvim_set_keymap('x', 'J', ':move \'>+1<CR>gv-gv', opt)
-- Better nav for omnicomplete
-- vim.cmd('inoremap <expr> <c-j> (\"\\<C-n>\")')
-- vim.cmd('inoremap <expr> <c-k> (\"\\<C-p>\")')
--
-- vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', opt)
-- Tab switch buffer
-- vim.api.nvim_set_keymap('n', '<TAB>', ':bnext<CR>', opt)
-- vim.api.nvim_set_keymap('n', '<S-TAB>', ':bprevious<CR>', opt)

--- {{{ Which Key
local wk = require("whichkey_setup")

require("whichkey_setup").config{
	hide_statusline = true,
	default_keymap_settings = {
		silent=true,
		noremap=true,
	},
	-- default_mode = 'n',
}

-- Hide some binding
local which_key_map = {}

which_key_map.h = 'which_key_ignore'
which_key_map.j = 'which_key_ignore'
which_key_map.k = 'which_key_ignore'
which_key_map.l = 'which_key_ignore'
which_key_map.s = 'which_key_ignore'
which_key_map.v = 'which_key_ignore'
which_key_map['P'] = {':lua require("nvim-peekup").peekup_open("P")<CR>', 'Paste!'}
which_key_map['p'] = {':lua require("nvim-peekup").peekup_open("p")<CR>', 'Paste'}
which_key_map["'"] = {':lua require("nvim-peekup").peekup_open()<CR>', 'Register'}

-- {{ ACTIONS }}
which_key_map.a = {
	name = '+Actions',
	s = {':%s/<c-r><c-w>//g<left><left>' , 'Subs Current Word'},
	S = {':%s/\\s\\+$//<CR>' , 'remove whitespace'},
	c = {':cd %:p:h<CR>:pwd<cr>' , 'cd to current'},
	C = {':lcd %:p:h<CR>:pwd<cr>', 'lcd to current'},
	x = {':!compiler %<CR>'      , 'Compile' },
	o = {':!opout %<CR>'         , 'Open with opout' },
	h = {':let v:hlsearch=!v:hlsearch<CR>' , 'remove search highlight'},
	-- remove but can rehighlighgt again
	-- h = {':let @/ = ""<CR>'      , 'remove search highlight'},
	m = {':MarkdownPreview<cr>'      , 'Markdown Preview'},
	M = {':MarkdownPreviewstop<cR>'  , 'Markdown Preview Stop'},
	l = {
		name = '+Liveserver',
		s = {':Bracey<CR>'      ,  'Start'},
		r = {':BraceyReload<cr>',  'Reload'},
		S = {':BraceyStop<cr>'  ,  'Stop'},
	},
	t = {
		name = '+Treesitter',
		k = {':TSHighlightcapturesUnderCursor<CR>', 'Treesitter Highlight'}
	},

}

-- {{ BUFFERS }}
which_key_map.b = {
	name = '+Buffer',
	c = {':BufferDelete<Cr>' , 'Delete Buffer'},
	f = {':BufferPick<CR>' , 'pick Buffer'},
	l = {':BufferNext<CR>' , 'next Buffer'},
	h = {':BufferPrevious<cr>' , 'Previous Buffer'},
	K = {':BufferMoveNext<cr>' , 'Move To Right'},
	J = {':BufferMovePrevious<cr>' , 'Move to left'},
	C = {':BufferCloseAllButCurrent<CR>' , 'Delete all other buffer'},
	x = {':BufferCloseAllButCurrent<CR>' , 'Delete all other buffer'},
	d = {':BufferDelete<Cr>' , 'Delete Buffer'},
	s = {':BufferOrderByDirectory<CR>' , 'Sort By Directory'},
	S = {':BufferOrderByLanguage<CR>' , 'Sort By Language'},
	G = {':BufferLast<CR>' , 'go to buffer Last'},
	g = {':BufferGoto 1<Cr>' , 'Go to Buffer 1'},
	b = {':Telescope buffers<cr>' , 'Switch Buffer'},
	['1'] = {':BufferGoto 1<cr>' , 'Go to Buffer 1'},
	['2'] = {':BufferGoto 2<cr>' , 'Go to Buffer 2'},
	['3'] = {':BufferGoto 3<cr>' , 'Go to Buffer 3'},
	['4'] = {':BufferGoto 4<cr>' , 'Go to Buffer 4'},
	['5'] = {':BufferGoto 5<cr>' , 'Go to Buffer 5'},
	['6'] = {':BufferGoto 6<cr>' , 'Go to Buffer 6'},
}

which_key_map.c = {
	name = '+Code',
	a = {':Lspsaga code_action<CR>'               , 'Code Action'},
	d = {':Telescope lsp_document_diagnostics<CR>', 'Document diagnostic'},
	r = {':Lspsaga rename<cr>'                    , 'Rename'},
	l = {':Lspsaga lsp_finder<cr>'                , 'Lsp Finder'},
	I = {':Lspinfo<CR>'                           , 'Lsp Info'},
  v = { ':LspVirtualTextToggle<CR>'                 , 'lsp toggle virtual text' },
  T = { ':LspVirtualTextToggle<CR>'                 , 'lsp toggle virtual text' },
	s = {':Telescope lsp_document_symbols<CR>'    , 'Document Symbols'},
	S = {':Telescope lsp_workspace_symbols<CR>'   , 'Workspace Symbols'},
	q = {':Telescope quickfix<cr>'  			  ,'quickfix'},
	p = {':Lspsaga preview_definition<CR>'        ,'preview definition'},
	t = {':Vista!!<CR>'                           , 'View and search Tags'},
}

-- {{ DEBUG }}
which_key_map.d = {
	name = '+Debug'
}

-- {{ FIND }}
which_key_map.f = {
	name = '+Find+Files',
	f = {':Telescope find_files<CR>'   , 'Files Current Dir' },
	r = {':Telescope oldfiles<cr>'     , 'Recent Files' },
	R = {':call RenameFile()<cr>', 'Rename Files' },
	y = {':call CopyFile()<cr>', 'Copy Files' },
	D = {':call delete(expand("%")) | echo "Deleted File" | BufferClose<CR>', 'Delete files' },
	m = {':Telescope media_files<CR>'  , 'Media Files' },
	t = {':Telescope live_grep<CR>'        , 'Grep text' },
	v = {':lua require("qs-telescope").find_neovim()<CR>', 'Tele Neovim Dir' },
	['.'] = {':lua require("qs-telescope").find_dot()<CR>', 'Tele dot Dir' },
	c = {':lua require("qs-telescope").find_chezdot()<CR>', 'Tele chez dot Dir' },
	x = {':lua require("qs-telescope").find_scripts()<CR>', 'Tele Scripts Dir' },
	s = {':lua require("qs-telescope").find_suck()<CR>', 'Tele suck Dir' },
}

-- {{ GIT }}
which_key_map.g = {
	name = '+Git',
	a = {':Git add'               , 'Add All'},
	b = {':GitBlameToggle<cr>'    , 'Blame'},
	B = {':GBrowse<CR>'           , 'Browse'},
	d = {':Git diff<CR>'          , 'Diff'},
	D = {':Gdiffsplit<CR>'        , 'Diff Split'},
	s = {':Gstatus<CR>'	          , 'Status'},
	j = {':Gitsigns next_hunk<cr>', 'Next Hunk'},
	k = {':Gitsigns prev_hunk<cr>', 'Previous Hunk'},
	l = {':Git Log<CR>'           , 'Log'},
	r = {':Gitsign reset_hunk<cr>', 'Reset Hunk'},
	R = {':Gitsign reset_buffer<CR>','Reset Buffer'},
	m = {'<Plug>(git-messenger)'  , 'Message'},
	u = {':Gitsigns undo_stage_hunk<CR>', 'Undo Hunk'},
	g = {':Gitsigns toggle_signs<CR>', 'Toggle Gutter'},
	T = {':Gitsigns toggle_signs<CR>', 'Toggle Gutter'},
	['1'] = {':FloatermNew lazygit<CR>', 'Lazygit'},
	['/'] = {
		name = '+Telescope-git',
		f = {':Telescope git_files<CR>','Files'},
		b = {':Telescope git_branches<CR>','Branches'},
		s = {':Telescope git_status<CR>','Status'},
		c = {':Telescope git_commit<CR>','Commit'},
		C = {':Telescope git_bcommit<CR>','Bcommit'},
	},
}

-- {{ HELP }}
which_key_map.H = {
	name = '+Help',
	k = {':map<CR>','Recent keys'},
	t = {':Telescope colorscheme<CR>', 'Load Theme'},
	v = {':Telescope vim_options<CR>' , 'Vim Options Setting' },
	m = {':Telescope man_pages<cR>','Man Page'},
	p = {':Telescope builtin<cr>','Telescope Picker List'},
	h = {':Telescope help_tags<cR>','Telescope Help'},
	[':'] = {':Telescope commands<CR>','List Commands'},
}

-- BOOKMARKS
which_key_map.m = {
	name = '+Bookmarks',
	a = {':BookmarkAnnotate<cr>','Annotate'},
	m = {':BookmarkToggle<cr>', 'Toggle Bookmarks'},
	T = {':BookmarkToggle<cr>', 'Toggle Bookmarks'},
	j = {':BookmarkNext<Cr>' , 'Next Mark' },
	k = {':BookmarkPrev<Cr>' , 'Previous Mark' },
	g = {':Telescope marks<cr>' , 'Jump to marks' },
}
-- {{ NOTES }}
which_key_map.n = {
	name = '+Notes',
	f = {':lua require("qs-telescope").find_notes()<CR>', 'Find Notes'},
	t = {':lua require("qs-telescope").find_todos()<CR>', 'Find Todos'},
	-- change this to buffer keymap only
	a = {':call dotoo#agenda#agenda()<CR>', 'Agenda View'},
	q = {'<Plug>OrgSetTags', 'org Set Tags'},
	-- t = {'<LocalLeader>d', 'org TOdo'},
	e = {
		name = '+export',
		p = {':OrgExportTopdf<cr>','PDF'},
		b = {':OrgExportTobeamerPDF<CR>','Beamer PDF'},
		l = {':OrgExportTolatex<CR>','Latex'},
		h = {':OrgExportTohtml<cR>','HTML'},
	},
}


which_key_map.q = {
	name = '+Quit',
	q  = {':qa<CR>','Quit'},
	Q  = {':qa!<CR>','Quit'},
	w  = {':xa!<CR>','Quit'}
}
-- {{ TOGGLE }}
which_key_map.t = {
	name = '+Toggle',
	s = {':setlocal spell! spelllang=en_us<CR>' , 'Spelling'},
	n = {':NvimTreeToggle<cr>' 	      , 'Nvim Tree'},
	t = {':FloatermToggle<cr>'            , 'Float Terminal ' },
	g = {':FloatermNew lazygit<CR>'   , 'Lazygit'},
	m = {':MarkdownPreviewtoggle<CR>' , 'Markdown Preview'},
	c = {':ColorizerToggle<cr>'       , 'Colorizer aka Color Highlight' },
	u = {':UndotreeToggle<cr>'        , 'Undotree' },
	f = {':Lf<CR>'                    , 'Lf' },
	z = {
		name = '+Zen',
		z = {':TZMinimalist<Cr>'          ,'Minimalist' },
		b = {':TZTop<CR>'                 ,'Top' },
		f = {':TZFocus<CR>'                 ,'Focus' },
		l = {':TZLeft<CR>'                 ,'Left' },
	},
	i = {':IndentBlanklineToggle<CR>' , 'Indent Line' },
	l = {':call g:ToggleLineMode()<CR>' , 'Line Mode' },
	h = {':lua require("specs").toggle()<CR>' , 'Nav Flash(Specs)' },
	['\\'] = {':ToggleTerm<cr>' , 'Terminal' },
}

-- {{ WINDOW }}
which_key_map.w = {
	name = '+Window',
	r = { '<C-w>r', 'Rotate'},
	R = { '<C-w>R', 'Rotate!'},
	w = { '<C-w>x', 'Swap??'},
	H = { '<C-w>H', 'Left!'},
	J = { '<C-w>J', 'Down!'},
	K = { '<C-w>K', 'Top!'},
	L = { '<C-w>L', 'Right!'},
	['-'] = { '<C-w>-', 'Dec Height'},
	['='] = { '<C-w>+', 'Inc Height'},
	['_'] = { '<C-w>5-', 'Dec Height'},
	['+'] = { '<C-w>5+', 'Inc Height'},
	[','] = { '<C-w><', 'Dec Width'},
	['.'] = { '<C-w>>', 'Inc Width'},
	['<'] = { '<C-w>5<', 'Dec Width'},
	['>'] = { '<C-w>5>', 'Inc Width'},
	['<BS>'] = { '<C-w>=', 'reset size'},
	['<TAB>'] = { '<C-w>T', 'Move to new Tab!'},
	['\\'] = {':MaximizerToggle<CR>', 'Maximizer'},
}

-- {{ TAB }}
which_key_map['<TAB>'] = {
	name = '+tab',
	c = {':tabc<CR>'  , 'Close'},
	C = {':tabonly<CR>'  , 'Close Other Tabs '},
	n = {':tabnew<CR>', 'New'},
	l = {':tabn<CR>'  , 'Next'},
	h = {':tabp<CR>'  , 'Previous'},
}

wk.register_keymap('leader', which_key_map)

-- wk.register_keymap('visual', which_key_visual_map)
-- }}}
