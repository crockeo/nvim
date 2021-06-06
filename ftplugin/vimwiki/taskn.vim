nmap <Plug>NoVimwikiFollowLink <Plug>VimwikiFollowLink
nnoremap <silent><buffer> <CR> :OpenTaskNote<CR>
nnoremap <silent><buffer> <C-c><C-o> :call vimwiki#base#follow_link('nosplit', 0, 1)<CR>
