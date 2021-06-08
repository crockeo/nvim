function! TaskNoteToggleSection()
    " A custom folding method to make sure that section folding works like it
    " does in orgmode:
    "
    "   - You have to be on the title line
    "   - Pressing fold from inside a section doesn't fold the entire section
    let header_level = 0
    let line = getline(".")
    for s:c in split(line, '\zs')
        if s:c == '#'
            let header_level += 1
        else
            break
        endif
    endfor

    if header_level == 0
        return
    endif

    let fold_level = foldlevel(".")
    if fold_level < header_level
        return
    endif

    if fold_level == 0
        return
    endif

    let closed = foldclosed(".")
    if closed != -1
        foldopen
    else
        foldclose
    endif
endfunction

" vimwiki runs ':set foldtext=VimwikiFoldText()'
" so we override it here by using the same name
function! VimwikiFoldText()
    return substitute(getline(v:foldstart), " | .*$", "", 1) . "..."
endfunction

set fillchars=fold:\  " NOTE: '\ ' here sets fold fill to space

nmap <Plug>NoVimwikiFollowLink <Plug>VimwikiFollowLink
nnoremap <silent><buffer> <CR> :OpenTaskNote<CR>
nnoremap <silent><buffer> <C-c><C-o> :call vimwiki#base#follow_link('nosplit', 0, 1)<CR>
nnoremap <silent><buffer> <Tab> :call TaskNoteToggleSection()<CR>
