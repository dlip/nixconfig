lua <<EOF
  vim.api.nvim_create_user_command("Reload", function(args)
    require('plenary.reload').reload_module('my', true)
    require('plenary.reload').reload_module('plugins', true)
    vim.cmd('source $MYVIMRC')
    print('Config Reloaded!')
  end, {
      nargs = "*",
      desc = "Reload Config",
  })
EOF

" reload config
nnoremap <C-M-R> <cmd>Reload<CR>

set shell=/run/current-system/sw/bin/bash

" use new lua filetype detection
let g:do_filetype_lua = 1
let g:did_load_filetypes = 0

let g:netrw_browsex_viewer = 'xdg-open'

" https://github.com/vim-test/vim-test
let g:test#go#runner = 'gotest'
let g:test#strategy = 'asyncrun_background'

function! DebugNearest()
  let g:test#go#runner = 'delve'
  let defaultStrategy = g:test#strategy
  let g:test#strategy = 'neovim'
  TestNearest
  let g:test#go#runner = 'gotest'
  let g:test#strategy = defaultStrategy
endfunction

" https://github.com/skywind3000/asyncrun.vim
let g:asyncrun_open = 8

" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1

" https://github.com/SidOfc/mkdx
let g:mkdx#settings     = { 'highlight': { 'enable': 1 },
                        \ 'enter': { 'shift': 1 },
                        \ 'links': { 'external': { 'enable': 1 } },
                        \ 'toc': { 'text': 'Table of Contents', 'update_on_write': 1 },
                        \ 'fold': { 'enable': 1 },
                        \ 'checkbox': { 'toggles': [' ', 'x'] }
                        \}

let g:polyglot_disabled = ['markdown'] " for vim-polyglot users, it loads Plasticboy's markdown
                                       " plugin which unfortunately interferes with mkdx list indentation.
" https://github.com/christoomey/vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1

" https://github.com/vimwiki/vimwiki
let g:vimwiki_list = [{'path': '~/notes/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

let g:vimwiki_key_mappings = { 'all_maps': 0, }

" https://github.com/glacambre/firenvim
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'markdown',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }

let g:ultest_deprecation_notice = 0

" https://github.com/neovide/neovide
let g:neovide_cursor_vfx_mode = 'railgun'
let g:neovide_transparency=0.8
" let g:neovide_window_floating_opacity=1

" Colorscheme
let g:nord_contrast = v:true
let g:nord_borders = v:false
let g:nord_disable_background = v:true
let g:nord_italic = v:false
colorscheme nord

" open a terminal pane on the bottom using :Term
command Term :botright split term://$SHELL

augroup vimrc
  autocmd!

  " Set transparent background
  autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NormalNC ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
  autocmd ColorScheme * highlight NvimTreeNormal ctermbg=NONE guibg=NONE

  " highlight on yank
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}

  " don't auto comment new lines
  autocmd BufEnter * set fo-=c fo-=r fo-=o

  " auto write new files
  autocmd BufNewFile * :write

  "remove line length marker for selected filetypes
  autocmd FileType text,markdown,xml,html,xhtml,javascript setlocal cc=0

  " 2 spaces for selected filetypes
  autocmd FileType python setlocal shiftwidth=4 tabstop=4

  " disable IndentLine for markdown files (avoid concealing)
  autocmd FileType markdown let g:indentLine_enabled=0

  " Terminal visual tweaks
  "- enter insert mode when switching to terminal
  "- close terminal buffer on process exit
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd TermOpen * setlocal winfixheight
  autocmd BufWinEnter,WinEnter term://* startinsert
  autocmd BufLeave term://* stopinsert

  " Restore enter functionality in quickfix window
  autocmd FileType qf nmap <buffer> <CR> <CR>

  " Close quickfix by q
  autocmd FileType qf nmap <buffer><silent> q :ccl<CR>
  autocmd FileType help nmap <buffer><silent> q :q<CR>
  autocmd BufWinEnter,WinEnter diffview://* nnoremap q :tabclose<cr>

  " Set filetypes
  autocmd BufEnter *.sol setlocal filetype=solidity

  " Use tabs for golang
  autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
augroup end


lua <<EOF
  require("my.init")
EOF
