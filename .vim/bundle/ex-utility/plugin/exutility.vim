
" variables {{{1

" }}}1

" highlight group {{{
hi default exTransparent gui=none guifg=background term=none cterm=none ctermfg=darkgray
hi default exCommentLable term=standout ctermfg=darkyellow ctermbg=Red gui=none guifg=lightgray guibg=red
hi default exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
hi default exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
" }}}

" commands {{{1
command! EXbn call ex#buffer#navigate('bn')
command! EXbp call ex#buffer#navigate('bp')
command! EXbalt call ex#buffer#to_alternate_edit_buf()
command! EXbd call ex#buffer#keep_window_bd()

command! EXsw call ex#window#switch_window()
command! EXgp call ex#window#goto_plugin_window()

command! EXplugins call ex#echo_registered_plugins()
" }}}1

" autocmd {{{1
augroup ex_utility
    au!
    au VimEnter,WinLeave * call ex#window#record()
    au BufLeave * call ex#buffer#record()
augroup END
" }}}1

" ex#register_plugin register plugins {{{
" register Vim builtin window
call ex#register_plugin( 'help', { 'buftype': 'help' } )
call ex#register_plugin( 'qf', { 'buftype': 'quickfix' } )
" }}}

" vim:ts=4:sw=4:sts=4 et fdm=marker:
