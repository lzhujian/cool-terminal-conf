" variables {{{1
let s:title = "-QFix-" 

let s:zoom_in = 0
let s:keymap = {}

let s:help_open = 0
let s:help_text_short = [
            \ '" Press <F1> for help',
            \ '',
            \ ]
let s:help_text = s:help_text_short

let s:compiler = "gcc" 
let s:qfix_file = './error.qfix'
" }}}

" functions {{{1

" exqfix#bind_mappings {{{2
function exqfix#bind_mappings()
    call ex#keymap#bind( s:keymap )
endfunction

" exqfix#register_hotkey {{{2
function exqfix#register_hotkey( priority, local, key, action, desc )
    call ex#keymap#register( s:keymap, a:priority, a:local, a:key, a:action, a:desc )
endfunction

" exqfix#toggle_help {{{2

" s:update_help_text {{{2
function s:update_help_text()
    if s:help_open
        let s:help_text = ex#keymap#helptext(s:keymap)
    else
        let s:help_text = s:help_text_short
    endif
endfunction

function exqfix#toggle_help()
    if !g:ex_qfix_enable_help
        return
    endif

    let s:help_open = !s:help_open
    silent exec '1,' . len(s:help_text) . 'd _'
    call s:update_help_text()
    silent call append ( 0, s:help_text )
    silent keepjumps normal! gg
    call ex#hl#clear_confirm()
endfunction

" exqfix#open_window {{{2

function exqfix#init_buffer()
    " NOTE: ex-project window open can happen during VimEnter. According to  
    " Vim's documentation, event such as BufEnter, WinEnter will not be triggered
    " during VimEnter.
    " When I open exqfix window and read the file through vimentry scripts,
    " the events define in exqfix/ftdetect/exqfix.vim will not execute.
    " I guess this is because when you are in BufEnter event( the .vimentry
    " enters ), and open the other buffers, the Vim will not trigger other
    " buffers' event 
    " This is why I set the filetype manually here. 
    set filetype=exqfix
    augroup exqfix
        au! BufWinLeave <buffer> call <SID>on_close()
    augroup END

    if line('$') <= 1 && g:ex_qfix_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
    else
        silent loadview
    endif
endfunction

function s:on_close()
    let s:zoom_in = 0
    let s:help_open = 0
    silent mkview

    " go back to edit buffer
    call ex#window#goto_edit_window()
    call ex#hl#clear_target()
endfunction

function exqfix#open_window()
    let winnr = winnr()
    if ex#window#check_if_autoclose(winnr)
        call ex#window#close(winnr)
    endif
    call ex#window#goto_edit_window()

    let winnr = bufwinnr(s:title)
    if winnr == -1
        call ex#window#open( 
                    \ s:title, 
                    \ g:ex_qfix_winsize,
                    \ g:ex_qfix_winpos,
                    \ 1,
                    \ 1,
                    \ function('exqfix#init_buffer')
                    \ )
    else
        exe winnr . 'wincmd w'
    endif
endfunction

" exqfix#toggle_window {{{2
function exqfix#toggle_window()
    let result = exqfix#close_window()
    if result == 0
        call exqfix#open_window()
    endif
endfunction

" exqfix#close_window {{{2
function exqfix#close_window()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        call ex#window#close(winnr)
        return 1
    endif
    return 0
endfunction

" exqfix#toggle_zoom {{{2
function exqfix#toggle_zoom()
    let winnr = bufwinnr(s:title)
    if winnr != -1
        if s:zoom_in == 0
            let s:zoom_in = 1
            call ex#window#resize( winnr, g:ex_qfix_winpos, g:ex_qfix_winsize_zoom )
        else
            let s:zoom_in = 0
            call ex#window#resize( winnr, g:ex_qfix_winpos, g:ex_qfix_winsize )
        endif
    endif
endfunction

" exqfix#confirm_select {{{2
" modifier: '' or 'shift'
function exqfix#confirm_select(modifier)
    " check if the line is valid file line
    let line = getline('.') 

    " get filename 
    let filename = line

    " NOTE: GSF,GSFW only provide filepath information, so we don't need special process.
    let idx = stridx(line, ':') 
    if idx > 0 
        let filename = strpart(line, 0, idx) "DISABLE: escape(strpart(line, 0, idx), ' ') 
    endif 

    " check if file exists
    if findfile(filename) == '' 
        call ex#warning( filename . ' not found!' ) 
        return
    endif 

    " confirm the selection
    let s:confirm_at = line('.')
    call ex#hl#confirm_line(s:confirm_at)

    " goto edit window
    call ex#window#goto_edit_window()

    " open the file
    if bufnr('%') != bufnr(filename) 
        exe ' silent e ' . escape(filename,' ') 
    endif 

    if idx > 0 
        " get line number 
        let line = strpart(line, idx+1) 
        let idx = stridx(line, ":") 
        let linestr = strpart(line, 0, idx)
        if 0 == match(linestr, "[0-9]")
            let linenr  = eval(linestr) 
            exec ' call cursor(linenr, 1)' 

            " jump to the pattern if the code have been modified 
            let pattern = strpart(line, idx+2) 
            let pattern = '\V' . substitute( pattern, '\', '\\\', "g" ) 
            if search(pattern, 'cw') == 0 
                call ex#warning('Line pattern not found: ' . pattern)
            endif 
        else
        endif
    endif 

    " go back to global search window 
    exe 'normal! zz'
    call ex#hl#target_line(line('.'))
    " call ex#window#goto_plugin_window()

endfunction

" exqfix#open {{{2
function exqfix#open(filename)
    let qfile = a:filename
    if qfile == ''
        let qfile = s:qfix_file
    endif

    if findfile(qfile) == ''
        call ex#warning( 'Can not find qfix file: ' . qfile )
        return
    endif

    " open the qfix window
    call exqfix#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_qfix_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 1
    endif

    " read qfix files
    let qfixlist = readfile(qfile)
    call append( start_line, qfixlist )

    " get the quick fix result
    silent exec 'cgetb'

    "
    call cursor( start_line, 0 )
endfunction

" exqfix#paste
function exqfix#paste(reg)
    " open the global search window
    call exqfix#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_gsearch_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 0
    endif

    silent put =getreg(a:reg)

    " get the quick fix result
    silent exec 'cgetb'

    "
    call cursor( start_line, 0 )

endfunction

" exqfix#build
function exqfix#build(opt)
    let result = system( &makeprg . ' ' . a:opt )

    " open the global search window
    call exqfix#open_window()

    " clear screen and put new result
    silent exec '1,$d _'

    " add online help 
    if g:ex_gsearch_enable_help
        silent call append ( 0, s:help_text )
        silent exec '$d'
        let start_line = len(s:help_text)
    else
        let start_line = 0
    endif

    silent put =result

    " get the quick fix result
    silent exec 'cgetb'

    "
    call cursor( start_line, 0 )
endfunction

" exqfix#goto
function exqfix#goto(idx)
    let idx = a:idx
    if idx == -1
        let idx = line('.')
    endif

    " start jump
    call ex#window#goto_edit_window()
    try
        silent exec "cr".idx
    catch /^Vim\%((\a\+)\)\=:E42/
        call ex#warning('No Errors')
    catch /^Vim\%((\a\+)\)\=:E325/ " this would happen when editting the same file with another programme.
        call ex#warning('Another programme is edit the same file.')
        try " now we try this again.
            silent exec 'cr'.idx
        catch /^Vim\%((\a\+)\)\=:E42/
            call ex#warning('No Errors')
        endtry
    endtry

    " go back
    exe 'normal! zz'
    call ex#hl#target_line(line('.'))
    call ex#window#goto_plugin_window()
endfunction

" exqfix#set_compiler
function exqfix#set_compiler(compiler)
    " setup compiler
    let s:compiler = a:compiler
    exec 'compiler! '. s:compiler
endfunction

" exqfix#set_qfix_file
function exqfix#set_qfix_file(path)
    let s:qfix_file = a:path
endfunction

" TODO: getqflist(), getloclist()

" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
