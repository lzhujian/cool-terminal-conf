" local settings {{{1
silent! setlocal buftype=nofile
silent! setlocal bufhidden=hide
silent! setlocal noswapfile
silent! setlocal nobuflisted

silent! setlocal cursorline
silent! setlocal nonumber
silent! setlocal nowrap
silent! setlocal statusline=
" }}}1

" Key Mappings {{{1
call extags#bind_mappings()
" }}}1

" autocmd {{{1
augroup ex_tags
    au!
    au CursorMoved <buffer> :call extags#cursor_moved()
augroup END
" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
