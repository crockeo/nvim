" TODO: migrate this over to denite.lua
"
" Taken from naquad on GitHub, over on
" https://github.com/Shougo/denite.nvim/issues/661#issuecomment-502390155
function! s:DeniteSetup() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <Esc>
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
        \ denite#do_map('toggle_select').'j'

  " some extra spice thrown in because i miss emacs :(
  noremap <silent><buffer><expr> <C-g>
        \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-g>
        \ denite#do_map('quit')
endfunction

" Somewhy this mess is working faster than <C-w>p and related commands.
" most probably related to the way win_gotoid handling autocommands
function! s:DeniteChoice(dir) abort
  let wid = win_findbuf(g:denite#_filter_parent)
  if empty(wid)
    return
  endif

  call win_gotoid(wid[0])

  if a:dir == 0
    norm k
  else
    norm j
  endif

  call win_gotoid(g:denite#_filter_winid)
endfunction

function! s:DeniteFilterSetup() abort
  let b:coc_enabled = 0

  imap <silent><buffer><expr> <CR> denite#do_map('do_action')
  imap <silent><buffer><expr> <C-j> denite#do_map('preview')
  imap <silent><buffer><expr> <Esc> denite#do_map('quit')

  imap <silent><buffer> <Up> <C-o>:call <SID>DeniteChoice(0)<CR>
  imap <silent><buffer> <Down> <C-o>:call <SID>DeniteChoice(1)<CR>

  " some extra spice thrown in because i miss emacs :(
  noremap <silent><buffer><expr> <C-g>
        \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <C-g>
        \ denite#do_map('quit')
endfunction


call denite#custom#option('_', {
      \ 'start_filter': 1,
      \ })

au FileType denite call s:DeniteSetup()
au FileType denite-filter call s:DeniteFilterSetup()
