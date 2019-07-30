" variables {{{1
let s:title = "-Tags-" 
let s:confirm_at = -1

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short

let s:tag_list = []
let s:tag = ''
let s:last_line_nr = -1
" }}}

" functions {{{1
" extags#bind_mappings {{{2
function extags#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" extags#register_hotkey {{{2
function extags#register_hotkey( priority, local, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" extags#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function extags#toggle_help()
    if !g:ex_tags_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" extags#open_window {{{2

function extags#init_buffer()
    set filetype=extags
    augroup extags
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_tags_enable_help
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

function extags#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_tags_winsize,
                    \ g:ex_tags_winpos,
                    \ 1,
                    \ 1,
                    \ function('extags#init_buffer')
                    \ )
        if s:confirm_at != -1
            call ex#hl#confirm_line(s:confirm_at)
        endif
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" extags#toggle_window {{{2
function extags#toggle_window()
    let result = extags#close_window()
    if result == 0
        call extags#open_window()
    endif
endfunction

" extags#close_window {{{2
function extags#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" extags#toggle_zoom {{{2
function extags#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_tags_winpos, g:ex_tags_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_tags_winpos, g:ex_tags_winsize )
        endif
    endif
endfunction

" extags#cursor_moved {{{2
function extags#cursor_moved()
    let line_num = line('.')
    if line_num == s:last_line_nr
        return
    endif

    while match(getline('.'), '^\s\+\d\+:') == -1
        if line_num > s:last_line_nr
            if line('.') == line('$')
                break
            endif
            silent exec 'normal! j'
        else
            if line('.') == 1
                silent exec 'normal! 2j'
                let s:last_line_nr = line_num - 1
            endif
            silent exec 'normal! k'
        endif
    endwhile

    let s:last_line_nr = line('.')
endfunction

" extags#confirm_select {{{2
" modifier: '' or 'shift'
function extags#confirm_select(modifier)
    " read current line as search pattern
    let cur_line = getline('.')
    if match(cur_line, '^        \S.*$') == -1
        call ex#warning('Pattern not found')
        return
    endif

    let idx = match(cur_line, '\S')
    let cur_line = strpart(cur_line, idx)
    let idx = match(cur_line, ':')
    let cur_tagidx = eval(strpart(cur_line, 0, idx))

    let s:confirm_at = line('.')
    call ex#hl#confirm_line(s:confirm_at)

    " jump by command
    call ex#window#goto_edit_window()

    " file jump
    let filename = fnamemodify(s:tag_list[cur_tagidx-1].filename,":p")
    let filename = fnameescape(filename)
    if a:modifier == 'shift'
        exe 'silent pedit ' . filename
        silent! wincmd P
        if &previewwindow
            let ex_cmd = s:tag_list[cur_tagidx-1].cmd
            try
                silent exe . ex_cmd
            catch /^Vim\%((\a\+)\)\=:E/
                " if ex_cmd is not digital, try jump again manual
                if match( ex_cmd, '^\/\^' ) != -1
                    let pattern = strpart(ex_cmd, 2, strlen(ex_cmd)-4)
                    let pattern = '\V\^' . pattern . (pattern[len(pattern)-1] == '$' ? '\$' : '')
                    if search(pattern, 'w') == 0
                        call ex#warning('search pattern not found: ' . pattern)
                        return
                    endif
                endif
            endtry
            call ex#hl#target_line(line('.'))
            wincmd p
        endif
        call ex#window#goto_plugin_window()
    else

    if bufnr('%') != bufnr(filename)
        exe ' silent e ' . filename
    endif

    " cursor jump
    let ex_cmd = s:tag_list[cur_tagidx-1].cmd
    try
        silent exe ex_cmd
    catch /^Vim\%((\a\+)\)\=:E/
        " if ex_cmd is not digital, try jump again manual
        if match( ex_cmd, '^\/\^' ) != -1
            let pattern = strpart(ex_cmd, 2, strlen(ex_cmd)-4)
            let pattern = '\V\^' . pattern . (pattern[len(pattern)-1] == '$' ? '\$' : '')
            if search(pattern, 'w') == 0
                call ex#warning('search pattern not found: ' . pattern)
                return
            endif
        endif
    endtry

    " go back to tags window
    exe 'normal! zz'
    call ex#hl#target_line(line('.'))
    call ex#window#goto_plugin_window()
    endif
endfunction

" extags#select {{{2

function s:convert_filename(filename)
    return fnamemodify( a:filename, ':t' ) . ' (' . fnamemodify( a:filename, ':h' ) . ')'    
endfunction

function s:put_taglist()

    " if empty tag_list, put the error result
    if empty(s:tag_list)
        silent put = 'Error: tag not found => ' . s:tag
        silent put = ''
        return
    endif

    " Init variable
    let idx = 1
    let pre_tag_name = s:tag_list[0].name
    let pre_file_name = s:tag_list[0].filename
    " put different file name at first
    silent put = pre_tag_name
    silent put = s:convert_filename(pre_file_name)
    " put search result
    for tag_info in s:tag_list
        if tag_info.name !=# pre_tag_name
            silent put = ''
            silent put = tag_info.name
            silent put = s:convert_filename(tag_info.filename)
        elseif tag_info.filename !=# pre_file_name
            silent put = s:convert_filename(tag_info.filename)
        endif
        " put search patterns
        let quick_view = ''
        if tag_info.cmd =~# '^\/\^' 
            let quick_view = strpart( tag_info.cmd, 2, strlen(tag_info.cmd)-4 )
            let quick_view = strpart( quick_view, match(quick_view, '\S') )
        elseif tag_info.cmd =~# '^\d\+'
            try
                let file_list = readfile( fnamemodify(tag_info.filename,":p") )
                let line_num = eval(tag_info.cmd) - 1 
                let quick_view = file_list[line_num]
                let quick_view = strpart( quick_view, match(quick_view, '\S') )
            catch /^Vim\%((\a\+)\)\=:E/
                let quick_view = "ERROR: can't get the preview from file!"
            endtry
        endif
        " this will change the \/\/ to //
        let quick_view = substitute( quick_view, '\\/', '/', "g" )
        silent put = '        ' . idx . ': ' . quick_view
        let idx += 1
        let pre_tag_name = tag_info.name
        let pre_file_name = tag_info.filename
    endfor

    " find the first item
    silent normal gg
    call search( '^\s*1:', 'w')
    let s:last_line_nr = line('.')
endfunction

function extags#select( tag )
    " strip white space.
    let in_tag = substitute (a:tag, '\s\+', '', 'g')
    if match(in_tag, '^\(\t\|\s\)') != -1
        return
    endif

    " get taglist
    " NOTE: we use \s\* which allowed the tag have white space at the end.
    "       this is useful for lua. In current version of cTags(5.8), it
    "       will parse the lua function with space if you define the function
    "       as: functon foobar () instead of functoin foobar(). 
    if g:ex_tags_ignore_case && (match(in_tag, '\u') == -1)
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(ignore case)'
        let tag_list = taglist('\V\^'.in_tag.'\s\*\$')
    else
        let in_tag = substitute( in_tag, '\', '\\\', "g" )
        echomsg 'parsing ' . in_tag . '...(no ignore case)'
        let tag_list = taglist('\V\^\C'.in_tag.'\s\*\$')
    endif

    let s:confirm_at = -1
    let s:tag = a:tag
    let s:tag_list = tag_list

    " open the global search window
    call extags#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_tags_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 0
    endif

    "
    call s:put_taglist ()
endfunction

" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
