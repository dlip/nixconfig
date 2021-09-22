" vim:fdm=marker

colorscheme gruvbox
set clipboard+=unnamedplus
" Plugin options {{{
" Highlight on yank
augroup LuaHighlight
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END
" }}}

" Keybindings {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" }}}
