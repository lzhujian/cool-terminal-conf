" variables {{{1
let s:title = "-Symbol-" 

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short
let s:symbols_file = './symbols'
" }}}

" functions {{{1
" exsymbol#bind_mappings {{{2
function exsymbol#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" exsymbol#register_hotkey {{{2
function exsymbol#register_hotkey( priority, local, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" exsymbol#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function exsymbol#toggle_help()
    if !g:ex_symbol_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" exsymbol#open_window {{{2

function exsymbol#init_buffer()
    set filetype=exsymbol
    augroup exsymbol
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_symbol_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
    endif
endfunction

function s:on_close()
    let s:zoom_in = 0
    let s:help_open = 0

    " go back to edit buffer
    call ex#window#goto_edit_window()
endfunction

function exsymbol#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_symbol_winsize,
                    \ g:ex_symbol_winpos,
                    \ 0,
                    \ 1,
                    \ function('exsymbol#init_buffer')
                    \ )
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" exsymbol#toggle_window {{{2
function exsymbol#toggle_window()
    let result = exsymbol#close_window()
    if result == 0
        call exsymbol#open_window()
    endif
endfunction

" exsymbol#close_window {{{2
function exsymbol#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" exsymbol#toggle_zoom {{{2
function exsymbol#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_symbol_winpos, g:ex_symbol_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_symbol_winpos, g:ex_symbol_winsize )
        endif
    endif
endfunction

" exsymbol#confirm_select {{{2
function exsymbol#confirm_select()
    let word = getline('.')
    if word == ''
        call ex#warning('Please select a symbol')
    endif

    " close the symbol window
    call exsymbol#close_window()

    " goto edit window
    call ex#window#goto_edit_window()

    exec 'redraw!'

    " tag select
    exec g:ex_symbol_select_cmd . ' ' . word
endfunction

" exsymbol#set_file {{{2
function exsymbol#set_file( path )
    let s:symbols_file = a:path
endfunction

" exsymbol#read_symbols {{{2
function exsymbol#list_all()
    if findfile(s:symbols_file) == ''
        call ex#warning( 'Can not find symbol file: ' . s:symbols_file . '. try :Update to generate it.' )
        return 0
    endif

    " open the symbol window
    call exsymbol#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_symbol_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 1
    endif

    " read symbol files
    let symbols = readfile(s:symbols_file)
    call append( start_line, symbols )

    return 1
endfunction

" exsymbol#list {{{2
function exsymbol#list( pattern )
    if exsymbol#list_all() == 0
        return
    endif

    call exsymbol#filter(a:pattern,0)
endfunction

" exsymbol#filter {{{2
" reverse: 0, 1
function exsymbol#filter( pattern, reverse )
    if a:pattern == ''
        call ex#warning('Search pattern is empty. Please provide your search pattern')
        return
    endif

    if g:ex_symbol_enable_help
        let start_line = len(s:help_text)+1
    else
        let start_line = 2
    endif
    let range = start_line.',$'

    " if reverse search, we first filter out not pattern line, then then filter pattern
    if a:reverse 
        silent exec range . 'g/' . a:pattern . '/d'
    else
        silent exec range . 'v/' . a:pattern . '/d'
    endif
    silent call cursor( start_line, 1 )
    call ex#hint('Filter: ' . a:pattern )
endfunction

" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
