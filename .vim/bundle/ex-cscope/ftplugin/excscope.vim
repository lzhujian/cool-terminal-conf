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
call excscope#bind_mappings()
