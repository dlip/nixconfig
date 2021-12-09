
lua <<EOF
reloadMyConfig = function()
  require('plenary.reload').reload_module('my', true)
  require('plenary.reload').reload_module('plugins', true)
  vim.cmd('source $MYVIMRC')
  print('Config Reloaded!')
end
EOF

" reload config
nnoremap <c-\> <cmd>lua reloadMyConfig()<CR>

let g:netrw_browsex_viewer = "xdg-open"

" https://github.com/vim-test/vim-test
let g:test#go#runner = 'gotest'
let g:test#strategy = 'asyncrun_background'

function! DebugNearest()
  let g:test#go#runner = 'delve'
  TestNearest
  let g:test#go#runner = 'gotest'
endfunction

" https://github.com/skywind3000/asyncrun.vim
let g:asyncrun_open = 8

" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled = 1

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

" Colors
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight NormalNC ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight NvimTreeNormal ctermbg=NONE guibg=NONE
colorscheme tokyonight

" open a terminal pane on the bottom using :Term
command Term :botright split term://$SHELL

augroup vimrc
  autocmd!
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

  " remove whitespace on save
  " autocmd BufWritePre * :%s/\s\+$//e

  " autoformat
  " augroup Format
  "     autocmd!
  "     autocmd BufWritePost * FormatWrite
  " augroup END

  " Restore enter functionality in quickfix window
  autocmd FileType qf nmap <buffer> <CR> <CR>

  " Close quickfix by q
  autocmd FileType qf nmap <buffer><silent> q :ccl<CR>
  autocmd FileType help nmap <buffer><silent> q :q<CR>
  autocmd BufWinEnter,WinEnter diffview://* nnoremap q :tabclose<cr>

  " Set filetypes
  autocmd BufEnter *.sol :setlocal filetype=solidity

  " Set package.json local key mappings
  autocmd BufEnter package.json :lua package_json_mappings()

  " Use tabs for golang
  autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

  " autoformat
  autocmd BufWritePre *.nix lua vim.lsp.buf.formatting_seq_sync(nil, 1000, { "rnix" })
  
augroup end

lua require'my.init'
