" variables {{{1
let s:title = "-Cscope-" 
let s:confirm_at = -1

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short

let s:cscope_list = []
let s:cscope = ''
let s:last_line_nr = -1

let s:csfile = './cscope.out'

" general
let s:excs_fold_start = '<<<<<<'
let s:excs_fold_end = '>>>>>>'
let s:excs_ignore_case = 1
let s:excs_need_search_again = 0

" quick view variable
let s:excs_quick_view_idx = 1
let s:excs_picked_search_result = []
let s:excs_quick_view_search_pattern = ''
" }}}

" functions {{{1
" excscope#bind_mappings {{{2
function excscope#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" excscope#register_hotkey {{{2
function excscope#register_hotkey( priority, local, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" excscope#toggle_help {{{2
" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function excscope#toggle_help()
    if !g:ex_cscope_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" excscope#open_window {{{2

function excscope#init_buffer()
    set filetype=excscope
    augroup excscope
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_cscope_enable_help
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

function excscope#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_cscope_winsize,
                    \ g:ex_cscope_winpos,
                    \ 1,
                    \ 1,
                    \ function('excscope#init_buffer')
                    \ )
        if s:confirm_at != -1
            call ex#hl#confirm_line(s:confirm_at)
        endif
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" excscope#toggle_window {{{2
function excscope#toggle_window()
    let result = excscope#close_window()
    if result == 0
        call excscope#open_window()
    endif
endfunction

" excscope#close_window {{{2
function excscope#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" excscope#toggle_zoom {{{2
function excscope#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_cscope_winpos, g:ex_cscope_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_cscope_winpos, g:ex_cscope_winsize )
        endif
    endif
endfunction

" excscope#set_csfile {{{2
function excscope#set_csfile(path)
    let s:csfile = a:path
endfunction

" excscope#connect {{{2
function excscope#connect()
    " don't show any message
	setlocal nocsverb
    " connect cscope files
    silent exec "cscope add " . s:csfile
	silent! setlocal cscopequickfix=s-,c-,d-,i-,t-,e-
endfunction 

function excscope#kill()
    " kill cscope files
    silent exec " cscope kill " . fnamemodify(s:csfile, ':p')
endfunction 


" excscope#goto {{{2
" goto select line
function excscope#goto(modifier)
    " check if the line can jump
    let line = getline('.')

    " process jump
    if line =~ '^ \[\d\+\]' " quickfix list jump
        " get the quick fix idx and item
        let start_idx = stridx(line,"[")+1
        let end_idx = stridx(line,"]")
        let qf_idx = str2nr( strpart(line, start_idx, end_idx-start_idx) )
        let qf_list = getqflist()
        let qf_item = qf_list[qf_idx]

        " start jump
        call ex#window#goto_edit_window()
        if a:modifier == 'shift'
            let linenr = qf_item.lnum
            let filename = bufname(qf_item.bufnr)
            exe 'silent pedit +'.linenr .' '. filename
            silent! wincmd P
            if &previewwindow
                call ex#hl#target_line(line('.'))
                wincmd p
            endif
            call ex#window#goto_plugin_window()
        else
        if bufnr('%') != qf_item.bufnr
            exe 'silent e ' . bufname(qf_item.bufnr)
        endif
        call cursor( qf_item.lnum, qf_item.col )
        endif
    elseif line =~ '^\S\+:\d\+:\s<<\S\+>>' " g method jump
        " get elements in location line ( file name, line )
        let line = getline('.')
        let elements = split ( line, ':' )

        " start jump
        if !empty(elements)
            call ex#window#goto_edit_window()
            if a:modifier == 'shift'
                let linenr = elements[1]
                let filename = elements[0]
                exe 'silent pedit +'.linenr .' '. filename
                silent! wincmd P
                if &previewwindow
                    call ex#hl#target_line(line('.'))
                    wincmd p
                endif
                call ex#window#goto_plugin_window()
            else
            exe 'silent e ' . elements[0]
            exec 'call cursor(elements[1], 1)'
        endif
        endif
    else
        call ex#warning("could not jump")
        return 0
    endif

    " go back if needed
    " let winnum = bufwinnr(s:title)
    " call ex#window#operate( winnum, g:exCS_close_when_selected, g:exCS_backto_editbuf, 1 )

    return 1
endfunction

" excscope#go_direct {{{2
function excscope#go_direct( search_method )
    let search_text = ''
    if a:search_method ==# 'i' " including file
        let search_text = expand("<cfile>".":t")
    else
        let search_text = expand("<cword>")
    endif

    call excscope#get_searchresult(search_text, a:search_method)
endfunction

" excscope#show_quickfixresult {{{2
function excscope#show_quickfixresult( search_method, g_method_result_list )
    " processing search result
    let result_list = getqflist()
    if !empty(a:g_method_result_list) 
        let result_list = a:g_method_result_list
    endif

    " processing result
    if a:search_method ==# 'da' " all called function
        let last_bufnr = -1
        let qf_idx = 0
        for item in result_list
            if last_bufnr != item.bufnr
                let convert_file_name = s:convert_filename( bufname(item.bufnr) )
                silent put = convert_file_name 
                let last_bufnr = item.bufnr
            endif
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %-40s | <%04d> %s", qf_idx, strpart( item.text, start_idx, len ), item.lnum, strpart( item.text, end_idx+2 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'ds' " select called function
        " TODO: " ::\S\+\_s\+(
 
       let cur_bufnr = ex#window#last_edit_bufnr()
        let qf_idx = 0
        for item in result_list
            if cur_bufnr == item.bufnr
                let start_idx = stridx( item.text, "<<")+2
                let end_idx = stridx( item.text, ">>")
                let len = end_idx - start_idx
                let text_line = printf(" [%03d] %-40s | <%04d> %s", qf_idx, strpart( item.text, start_idx, len ), item.lnum, strpart( item.text, end_idx+2 ) )
                silent put = text_line 
            endif
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'c' " calling function
        let qf_idx = 0
        for item in result_list
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %s:%d: <<%s>> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, start_idx, len ), strpart( item.text, end_idx+2 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'i' " including file
        let qf_idx = 0
        for item in result_list
            let convert_file_name = s:convert_filename( bufname(item.bufnr) )
            let start_idx = stridx( convert_file_name, "(")
            let short_name = strpart( convert_file_name, 0, start_idx )
            let path_name = strpart( convert_file_name, start_idx )
            let text_line = printf(" [%03d] %-36s <%02d> %s", qf_idx, short_name, item.lnum, path_name )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 's' " C symbol
        let qf_idx = 0
        for item in result_list
            let start_idx = stridx( item.text, "<<")+2
            let end_idx = stridx( item.text, ">>")
            let len = end_idx - start_idx
            let text_line = printf(" [%03d] %s:%d: <<%s>> %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, start_idx, len ), strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    elseif a:search_method ==# 'g' " definition
        let text = ''
        for item in result_list
            if item =~# '^\S\+' || item =~# '^\s\+\#\s\+line\s\+filename \/ context \/ line'
                continue
            endif

            " if this is a location line
            if item =~# '^\s\+\d\+\s\+\d\+\s\+\S\+\s\+<<\S\+>>'
                let elements = split ( item, '\s\+' )
                if len(elements) == 4  
                    let text = elements[2].':'.elements[1].':'.' '.elements[3]
                else
                    call ex#warning ('invalid line')
                endif
                continue
            endif

            " put context line
            let context = strpart( item, match(item, '\S') )
            silent put = text . ' ' . context 
        endfor
    elseif a:search_method ==# 'e' " egrep
        let qf_idx = 0
        for item in result_list
            let end_idx = stridx( item.text, ">>")
            let text_line = printf(" [%03d] %s:%d: %s", qf_idx, bufname(item.bufnr), item.lnum, strpart( item.text, end_idx+3 ) )
            silent put = text_line 
            let qf_idx += 1
        endfor
    else
        call ex#warning("Wrong search method")
        return
    endif
endfunction

" excscope#parse_function {{{2
function excscope#parse_function()
    " if we have taglist use it
    if exists(':Tlist')
        silent exec "TlistUpdate"
        let search_text = Tlist_Get_Tagname_By_Line()
        if search_text == ""
            call ex#warning("pattern not found, you're not in a function")
            return
        endif
    else
        let search_text = expand("<cword>")
    endif
    call excscope#get_searchresult(search_text, 'ds')
endfunction

" excscope#get_searchresult {{{2
" Get Global Search Result
" search_pattern = ''
" search_method = -s / -r / -w

function excscope#get_searchresult(search_pattern, search_method)
    " if cscope file not connect, connect it
    if cscope_connection(2, fnamemodify(s:csfile, ':p') ) == 0
        call excscope#connect()
    endif

    " jump back to edit buffer first
    call ex#window#goto_edit_window()

    " change window for suitable search method
    let search_result = ''
    let g:excs_use_vertical_window = 0
    let g:excs_window_direction = 'bel'

    if a:search_method =~# '\(d\|i\)'
        let g:excs_use_vertical_window = 1
        let g:excs_window_direction = 'botright'
    elseif a:search_method ==# 'g' " NOTE: the defination result not go into quickfix list
        silent redir =>search_result
    endif

    " start processing cscope
    let search_cmd = 'cscope find ' . a:search_method . ' ' . a:search_pattern
    try
        silent exec search_cmd
    catch /^Vim\%((\a\+)\)\=:E259/
        "call ex#warning("no matches found for " . a:search_pattern )
        echohl WarningMsg
        echon "no matches found for " . a:search_pattern . "\r"
        echohl None
        return
    endtry

    " finish redir if it is method 'g'
    let result_list = []
    if a:search_method ==# 'g' 
        silent redir END
        let result_list = split( search_result, "\n" ) 

        " NOTE: in cscope find g, if there is no search result, that means it
        "       only have one result, and it will perform a jump directly
        if len(result_list) == 1
            return
        endif
    else
        " go back 
        silent exec "normal! \<c-o>"
    endif

    " open and goto search window first
    let cs_winnr = bufwinnr(s:title)
    if cs_winnr != -1
        call excscope#close_window()
    endif
    " call excscope#ToggleWindow('Select')
    call excscope#toggle_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_cscope_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 0
    endif

    let s:confirm_at = line('.')
    call ex#hl#confirm_line(s:confirm_at)

    " processing search result
    let search_method_text = 'unknown'
    if a:search_method ==# 'da' " all called function
        let search_method_text = '(called functions all)'
    elseif a:search_method ==# 'ds' " select called function
        let search_method_text = '(called functions current)'
    elseif a:search_method ==# 'c' " calling function
        let search_method_text = '(calling functions)'
    elseif a:search_method ==# 'i' " including file
        let search_method_text = '(including files)'
    elseif a:search_method ==# 's' " C symbol
        let search_method_text = '(C symbols)'
    elseif a:search_method ==# 'g' " definition
        let search_method_text = '(definitions)'
    elseif a:search_method ==# 'e' " egrep
        let search_method_text = '(egrep results)'
    endif

    let pattern_title = '----------' . a:search_pattern . ' ' . search_method_text . '----------'
    silent put = pattern_title 
    call excscope#show_quickfixresult( a:search_method, result_list )

    " Init search state
    silent normal gg
    let line_num = search(pattern_title)
    silent call cursor( line_num+1, 1 )
    silent normal zz
endfunction


" excscope#copy_pickedline {{{2
function excscope#copy_pickedline( search_pattern, line_start, line_end, search_method, inverse_search ) 
    if a:search_pattern == ''
        let search_pattern = @/
    else
        let search_pattern = a:search_pattern
    endif
    if search_pattern == ''
        let s:excs_quick_view_search_pattern = ''
        call ex#warning('search pattern not exists')
        return
    else
        let s:excs_quick_view_search_pattern = '----------' . search_pattern . '----------'
        let full_search_pattern = search_pattern
        " DISABLE { 
        " if a:search_method == 'pattern'
        "     let full_search_pattern = '^ \[\d\+\]\S\+<\d\+>.*\zs' . search_pattern
        " elseif a:search_method == 'file'
        "     let full_search_pattern = '\(.\+<\d\+>\)\&' . search_pattern
        " endif
        " } DISABLE end 
        " save current cursor position
        let save_cursor = getpos(".")
        " clear down lines
        if a:line_end < line('$')
            silent call cursor( a:line_end, 1 )
            silent exec 'normal! j"_dG'
        endif
        " clear up lines
        if a:line_start > 1
            silent call cursor( a:line_start, 1 )
            silent exec 'normal! k"_dgg'
        endif
        silent call cursor( 1, 1 )

        " clear the last search result
        if !empty( s:excs_picked_search_result )
            silent call remove( s:excs_picked_search_result, 0, len(s:excs_picked_search_result)-1 )
        endif

        " if inverse search, we first filter out not pattern line, then
        " then filter pattern
        if a:inverse_search
            " DISABLE: let search_results = '\(.\+<\d\+>\).*'
            let search_results = '\S\+'
            silent exec 'v/' . search_results . '/d'
            silent exec 'g/' . full_search_pattern . '/d'
        else
            silent exec 'v/' . full_search_pattern . '/d'
        endif

        " clear pattern result
        while search('----------.\+----------', 'w') != 0
            silent exec 'normal! "_dd'
        endwhile

        " copy picked result
        let s:excs_picked_search_result = getline(1,'$')

        " recover
        silent exec 'normal! u'

        " go back to the original position
        silent call setpos(".", save_cursor)
    endif
endfunction 

" excscope#get_searchresult {{{2
" show the picked result in the quick view window
function excscope#show_pickedresult( search_pattern, line_start, line_end, edit_mode, search_method, inverse_search )
    call excscope#copy_pickedline( a:search_pattern, a:line_start, a:line_end, a:search_method, a:inverse_search )
    " call excscope#SwitchWindow('QuickView')
    call excscope#open_window()
    if a:edit_mode == 'replace'
        silent exec '1,$d _'
        let s:excs_quick_view_idx = 1
        let s:confirm_at = line('.')
        call ex#hl#confirm_line(s:confirm_at)

        silent put = s:excs_quick_view_search_pattern
        silent put = s:excs_fold_start
        silent put = s:excs_picked_search_result
        silent put = s:excs_fold_end
        silent call search('<<<<<<', 'w')
    elseif a:edit_mode == 'append'
        silent exec 'normal! G'
        silent put = ''
        silent put = s:excs_quick_view_search_pattern
        silent put = s:excs_fold_start
        silent put = s:excs_picked_search_result
        silent put = s:excs_fold_end
    endif
endfunction

" " excscope#cursor_moved {{{2
" function excscope#cursor_moved()
"     let line_num = line('.')
"     if line_num == s:last_line_nr
"         return
"     endif

"     while match(getline('.'), '^\s\+\d\+:') == -1
"         if line_num > s:last_line_nr
"             if line('.') == line('$')
"                 break
"             endif
"             silent exec 'normal! j'
"         else
"             if line('.') == 1
"                 silent exec 'normal! 2j'
"                 let s:last_line_nr = line_num - 1
"             endif
"             silent exec 'normal! k'
"         endif
"     endwhile

"     let s:last_line_nr = line('.')
" endfunction

" excscope#confirm_select {{{2
" modifier: '' or 'shift'
function excscope#confirm_select(modifier)
    let s:confirm_at = line('.')
    call ex#hl#confirm_line(s:confirm_at)
    call excscope#goto(a:modifier)
endfunction

" excscope#select {{{2
function s:convert_filename(filename)
    return fnamemodify( a:filename, ':t' ) . ' (' . fnamemodify( a:filename, ':h' ) . ')'    
endfunction

" vim: set foldmethod=marker foldmarker=<<<,>>> foldlevel=9999:
