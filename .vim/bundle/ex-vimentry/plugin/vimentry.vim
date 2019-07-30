let g:ex_vim_entered = 0

function! s:on_vim_enter()
    let g:ex_vim_entered = 1
endfunction

" autocmd {{{
augroup ex_vimentry
    au!
    au VimEnter * call <SID>on_vim_enter()
augroup END
" }}}

" vim:ts=4:sw=4:sts=4 et fdm=marker:
