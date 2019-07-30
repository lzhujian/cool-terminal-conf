" variables {{{1
let s:title = "-Hierarchy-" 
let s:confirm_at = -1

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short

let s:inherits_file = './inherits'
let s:dot_file = './hv.dot'
let s:img_file = './hv.png'
" }}}

" functions {{{1
" exhierarchy#bind_mappings {{{2
function exhierarchy#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" exhierarchy#register_hotkey {{{2
function exhierarchy#register_hotkey( priority, local, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" exhierarchy#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function exhierarchy#toggle_help()
    if !g:ex_hierarchy_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" exhierarchy#open_window {{{2

function exhierarchy#init_buffer()
    set filetype=exhierarchy
    augroup exhierarchy
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_hierarchy_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
    endif
endfunction

function s:on_close()
    let s:zoom_in = 0
    let s:help_open = 0

    " go back to edit buffer
    call ex#window#goto_edit_window()
    call ex#hl#clear_target()
endfunction

function exhierarchy#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_hierarchy_winsize,
                    \ g:ex_hierarchy_winpos,
                    \ 1,
                    \ 1,
                    \ function('exhierarchy#init_buffer')
                    \ )
        if s:confirm_at != -1
            call ex#hl#confirm_line(s:confirm_at)
        endif
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" exhierarchy#toggle_window {{{2
function exhierarchy#toggle_window()
    let result = exhierarchy#close_window()
    if result == 0
        call exhierarchy#open_window()
    endif
endfunction

" exhierarchy#close_window {{{2
function exhierarchy#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" exhierarchy#toggle_zoom {{{2
function exhierarchy#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_hierarchy_winpos, g:ex_hierarchy_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_hierarchy_winpos, g:ex_hierarchy_winsize )
        endif
    endif
endfunction

" exhierarchy#view {{{2

function s:get_children_recursively(parsed_pattern, inherits_list, file_list)
    let result_list = []
    for inherit in a:inherits_list
        " change to parent pattern
        let pattern = strpart( inherit, stridx(inherit,"->")+3 ) . ' ->'

        " skip parsed pattern
        if index( a:parsed_pattern, pattern ) >= 0
            continue
        endif
        call add( a:parsed_pattern, pattern )

        " add children list
        let children_list = filter( copy(a:file_list), 'v:val =~# pattern' )
        let result_list += children_list 

        " recursive the children
        let result_list += s:get_children_recursively( a:parsed_pattern, children_list, a:file_list ) 
    endfor
    return result_list
endfunction 

function s:get_parent_recursively(parsed_pattern, inherits_list, file_list)
    let result_list = []
    for inherit in a:inherits_list
        " change to child pattern
        let pattern =  '-> ' . strpart( inherit, 0, stridx(inherit,"->")-1 )

        " skip parsed pattern
        if index( a:parsed_pattern, pattern ) >= 0
            continue
        endif
        call add( a:parsed_pattern, pattern )

        " add pattern list
        let parent_list = filter( copy(a:file_list), 'v:val =~# pattern' )
        let result_list += parent_list 

        " recursive the parent
        let result_list += s:get_parent_recursively( a:parsed_pattern, parent_list, a:file_list ) 
    endfor
    return result_list
endfunction

function s:get_inherits( name, method )
    " find inherits file
    if findfile ( s:inherits_file ) == ''
        call ex#warning ( s:inherits_file . ' not exists.')
        return []
    endif

    " read the inherits file
    let file_list = readfile( s:inherits_file )

    " init value
    let parsed_pattern = []
    let inherits_list = []

    " process by method
    if a:method == 'all'
        let parent_pattern = '-> "' . a:name . '"'
        let child_pattern = '"' . a:name . '" ->'

        " filter
        let parent_inherits_list = filter( copy(file_list), 'v:val =~ parent_pattern' )
        let inherits_list += parent_inherits_list
        let children_inherits_list = filter( copy(file_list), 'v:val =~ child_pattern' )
        let inherits_list += children_inherits_list

        " processing inherits
        let inherits_list += s:get_parent_recursively( parsed_pattern, parent_inherits_list, file_list )
        let inherits_list += s:get_children_recursively( parsed_pattern, children_inherits_list, file_list )
    else
        if a:method == 'parent'
            let pattern = '-> "' . a:name . '"'
        elseif a:method == 'children'
            let pattern = '"' . a:name . '" ->'
        endif

        " first filter
        let tmp_inherits_list = filter( copy(file_list), 'v:val =~ pattern' )
        let inherits_list += tmp_inherits_list

        " processing inherits
        if a:method == 'parent'
            let inherits_list += s:get_parent_recursively( parsed_pattern, tmp_inherits_list, file_list )
        elseif a:method == 'children'
            let inherits_list += s:get_children_recursively( parsed_pattern, tmp_inherits_list, file_list )
        endif
    endif

    " 
    return inherits_list
endfunction

" method: 'all', 'parent', 'children'
function exhierarchy#view( name, method )
    " generate dot file
    echomsg 'Generating dot for ' . a:name 
    let inherits_list = s:get_inherits( a:name, a:method )
    let inherits_list = ['digraph INHERITS {', 'rankdir=LR;'] + inherits_list + ['}']
    call writefile(inherits_list, s:dot_file, 'b')

    "
    let dot_cmd = '!dot "' . s:dot_file . '" -Tpng -o"' . s:img_file . '"'
    silent exec dot_cmd

    "
    call ex#os#open(s:img_file)
endfunction

" {{{2
function exhierarchy#set_inheirts_file( path )
    let s:inherits_file = a:path
endfunction

" {{{2
function exhierarchy#set_dot_file( path )
    let s:dot_file = a:path
endfunction

" {{{2
function exhierarchy#set_img_file( path )
    let s:img_file = a:path
endfunction

" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
