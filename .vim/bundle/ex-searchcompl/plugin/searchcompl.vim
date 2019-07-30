" This script catches the <Tab> character when using the '/' search
" command.  Pressing Tab will expand the current partial word to the
" next matching word starting with the partial word.
" If you want to match a tab, use the '\t' pattern.

" disable the searchcompl in xterm in linux/unix.
" because of the <ESC> mapping problem in xterm
if !has("gui_running") && has("unix")
    let g:loaded_searchcompl = 1
endif

" check if plugin loaded
if exists('g:loaded_searchcompl') || &cp
    finish
endif
let g:loaded_searchcompl = 1

" variables {{{1
let s:usr_input = ''
let s:init_search_input = 1
let s:result = ''
"}}}
" functions {{{1
" s:search_compl_start {{{2
" Desc: Set mappings for search complete
function s:search_compl_start()
    let s:init_search_input = 1
    cnoremap <S-Tab> <C-R>=<SID>search_compl(0)<CR>
    cnoremap <Tab> <C-R>=<SID>search_compl(1)<CR>
    cnoremap <silent> <CR> <CR>:call <SID>search_compl_stop()<CR>
    cnoremap <silent> <Esc> <C-C>:call <SID>search_compl_stop()<CR>
endfunction

" s:search_compl {{{2
" Desc: Tab completion in / search
function s:search_compl(forward)
    let jump = 1
    if s:init_search_input == 1
        let s:usr_input = getcmdline()
        let s:init_search_input = 0
        let jump = 0
    endif

    let cmdline = getcmdline()
    let result = s:get_next_match_result(jump,a:forward)
    let s:result = substitute(cmdline, ".", "\<c-h>", "g") . result
    return s:result
endfunction

" s:get_next_match_result {{{2
function s:get_next_match_result( jump, forward )
    " first time search needn't jump
    if a:jump
        if a:forward == 1
            silent call search ( s:usr_input, 'cwe' )
        else
            silent call search ( s:usr_input, 'bwe' )
        end

        " cause the / search mechanism don't allow cursor jump (though it jumped.),
        " so for next search result, it will get the whole word
        let cur_word = expand('<cword>')
        return '\<'.cur_word.'\>'
    endif

    " first time search
    let search_end_col = col( "." )
    let search_start_col = search_end_col - strlen(s:usr_input)

    silent exec "normal b"
    let cur_word = expand('<cword>')
    let word_start_col = col( "." )

    " for first time search result, you can get partial word.
    return strpart( cur_word, search_start_col-word_start_col )
endfunction

" s:search_compl_stop {{{2
" Desc: Remove search complete mappings
function s:search_compl_stop()
    cunmap <S-Tab>
    cunmap <Tab>
    cunmap <CR>
    cunmap <Esc>
    let s:init_search_input = 0
endfunction
"}}}1
" key mappings {{{
noremap <Plug>StartSearch :call <SID>search_compl_start()<CR>/
nmap / <Plug>StartSearch
"}}}

" vim:ts=4:sw=4:sts=4 et fdm=marker:
