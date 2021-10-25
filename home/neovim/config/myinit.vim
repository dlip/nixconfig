
" gx not working https://github.com/vim/vim/issues/4737
let g:netrw_browsex_viewer = "xdg-open"

let test#go#runner = 'gotest'

" Fugitive
let g:nremap = {'s': 'e', 'r': 'b'}
let g:xremap = {'s': 'e', 'r': 'b'}
let g:oremap = {'s': 'e', 'r': 'b'}

" https://github.com/christoomey/vim-tmux-navigator
let g:tmux_navigator_no_mappings = 1

" Colors
autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight NormalNC ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight SignColumn ctermbg=NONE guibg=NONE
autocmd ColorScheme * highlight NvimTreeNormal ctermbg=NONE guibg=NONE
colorscheme tokyonight

" open a terminal pane on the right using :Term
command Term :botright split term://$SHELL

" highlight on yank
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=300}
augroup end

" don't auto comment new lines
autocmd BufEnter * set fo-=c fo-=r fo-=o

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

" Restore enter functionality in quickfix window
autocmd FileType qf nmap <buffer> <CR> <CR>

" Close quickfix by q
autocmd FileType qf nmap <buffer><silent> q :ccl<CR>
autocmd FileType help nmap <buffer><silent> q :q<CR>
autocmd BufWinEnter,WinEnter diffview://* nnoremap q :tabclose<cr>

" PageUp/PageDown
"     nnoremap <silent> <expr> j (winheight(-1)-1) . "\<C-u>"
"     nnoremap <silent> <expr> h (winheight(-1)-1) . "\<C-d>"
"     xnoremap <silent> <expr> j (winheight(-1)-1) . "\<C-u>"
"     xnoremap <silent> <expr> h (winheight(-1)-1) . "\<C-d>"
"     nnoremap <silent> <expr> <PageUp> (winheight(-1)-1) . "\<C-u>"
"     nnoremap <silent> <expr> <PageDown> (winheight(-1)-1) . "\<C-d>"
"     vnoremap <silent> <expr> <PageUp> (winheight(-1)-1) . "\<C-u>"
"     vnoremap <silent> <expr> <PageDown> (winheight(-1)-1) . "\<C-d>"
"     vnoremap <silent> <expr> <S-PageUp> (winheight(-1)-1) . "\<C-u>"
"     vnoremap <silent> <expr> <S-PageDown> (winheight(-1)-1) . "\<C-d>"

" Set filetypes
autocmd BufEnter *.sol :setlocal filetype=solidity

lua require'init'
