" ex#window#new {{{
" bufname: the buffer you wish to open a window edit it
" size: the initial size of the window
" pos: 'left', 'right', 'top', 'bottom'
" nested: 0 or 1. if nested, the window will be created besides current window 

function ex#window#new( bufname, size, pos, nested, callback )
    let winpos = ''
    if a:nested == 1
        if a:pos == 'left' || a:pos == 'top'
            let winpos = 'leftabove'
        elseif a:pos == 'right' || a:pos == 'bottom'
            let winpos = 'rightbelow'
        endif
    else
        if a:pos == 'left' || a:pos == 'top'
            let winpos = 'topleft'
        elseif a:pos == 'right' || a:pos == 'bottom'
            let winpos = 'botright'
        endif
    end

    let vcmd = ''
    if a:pos == 'left' || a:pos == 'right'
        let vcmd = 'vertical'
    endif

    " If the buffer already exists, reuse it.
    " Otherwise create a new buffer
    let bufnum = bufnr(a:bufname)
    let bufcmd = ''
    if bufnum == -1
        " Create a new buffer
        let bufcmd = fnameescape(a:bufname)
    else
        " Edit exists buffer
        " NOTE: '+' here is to make it work with other command 
        let bufcmd = '+b' . bufnum
    endif

    " Create the ex_window
    silent exe winpos . ' ' . vcmd . ' ' . a:size . ' split ' .  bufcmd

    " init window 

    " the winfix height width will let plugin-window not join into the <c-w>= operations
    silent setlocal winfixheight
    silent setlocal winfixwidth

    call a:callback()
endfunction

" ex#window#open {{{
" bufname: the buffer you wish to open a window edit it
" size: the initial size of the window
" pos: 'left', 'right', 'top', 'bottom'
" nested: 0 or 1. if nested, the window will be created besides current window 
" focus: 0 or 1. if focus, we will move cursor to opened window
" callback: init callback when window created

function ex#window#open( bufname, size, pos, nested, focus, callback )
    " TODO:
    " " close ex_plugin window in same position
    " call exUtility#ClosePluginWindowInSamePosition ( position, nested )

    " " go to edit buffer first, then open the window, this will avoid some bugs
    " call exUtility#RecordCurrentBufNum()
    " call exUtility#GotoEditBuffer()

    " new window
    call ex#window#new( a:bufname, a:size, a:pos, a:nested, a:callback )

    "
    if a:focus == 0
        call ex#window#goto_edit_window()
    endif
endfunction

" ex#window#close {{{
function ex#window#close(winnr)
    if a:winnr == -1
        return
    endif

    " jump to the window
    exe a:winnr . 'wincmd w'

    " if this is not the only window, close it
    " if winbufnr(2) != -1
    "     close
    " endif
    try
        close
    catch /E444:/
        call ex#warning( 'Can not close last window' )
    endtry

    " this will help BufEnter event correctly happend when we enter the edit window 
    doautocmd BufEnter
endfunction

" ex#window#resize {{{
function ex#window#resize( winnr, pos, new_size )
    let vcmd = ''
    if a:pos == 'left' || a:pos == 'right'
        let vcmd = 'vertical'
    endif

    " jump to the window
    exe a:winnr . 'wincmd w'
    silent exe vcmd . ' resize ' . a:new_size
endfunction

" ex#window#record {{{

" NOTE: Vim's window is manage by winnr. however, winnr will change when
" there's window closed. Basically, win sort the all exists window, and  
" give them winnr by the created time. This is bad for locate window in 
" the runtime. 

" NOTE: The WinEnter,WinLeave, event will not invoke during VimEnter
" That's why I don't init w:ex_winid when WinEnter

" NOTE: Cause Vim not fire WinEnter,WinLeave event during VimEnter,
" When you open window at the starting of Vim, you need to manually invoke
" the code. You can do this by:
"       call ex#window#record()
" or
"       doautocmd WinLeave 

" What we do is when window leaving, give it a w:ex_winid 
" that holds a unique id.

let s:last_editbuf_winid = -1
let s:last_editplugin_bufnr = -1
let s:winid_generator = 0

function s:new_winid () 
    let s:winid_generator = s:winid_generator + 1
    return s:winid_generator
endfunction

function s:winid2nr (winid)
    if a:winid == -1
        return -1
    endif

    let i = 1
    let winnr = winnr('$')
    while i <= winnr
        if getwinvar(i, 'ex_winid') == a:winid
            return i
        endif
        let i = i + 1
    endwhile
    return -1
endfunction

function ex#window#record()
    if getwinvar(0, 'ex_winid') == ''
        let w:ex_winid = s:new_winid()
    endif

    let winnr = winnr()
    let bufopts = []
    " if this is plugin window and do not have {action: norecord} 
    if ex#is_registered_plugin( winbufnr(winnr), bufopts )
        if index( bufopts, 'norecord' ) == -1
            let s:last_editplugin_bufnr = bufnr('%')
        endif
    else
        let s:last_editbuf_winid = w:ex_winid
    endif
endfunction

" DEBUG
function ex#window#debug () 
    echomsg "last edit window id = " . s:last_editbuf_winid
    echomsg "last edit buffer = " . bufname(ex#window#last_edit_bufnr())
    echomsg "last edit plugin = " . bufname(s:last_editplugin_bufnr)
endfunction

" ex#window#is_plugin_window {{{
function ex#window#is_plugin_window( winnr )
    return ex#is_registered_plugin(winbufnr(a:winnr))
endfunction

" ex#window#last_edit_bufnr {{{
function ex#window#last_edit_bufnr()
    return winbufnr(s:winid2nr(s:last_editbuf_winid))
endfunction

" ex#window#check_if_autoclose {{{
function ex#window#check_if_autoclose( winnr )
    let bufopts = []
    if ex#is_registered_plugin( winbufnr(a:winnr), bufopts )
        if index( bufopts, 'autoclose' ) != -1
            return 1
        endif
    endif
    return 0
endfunction

" ex#window#goto_edit_window {{{
function ex#window#goto_edit_window()
    " if current window is edit_window, don't do anything
    let winnr = winnr()
    if !ex#window#is_plugin_window(winnr)
        return
    endif


    " get winnr from winid
    let winnr = s:winid2nr(s:last_editbuf_winid)

    " if we have edit window opened, jump to it
    " if something wrong make you delete the edit window (such as :q)
    " we will try to search another edit window, 
    " if no edit window exists, we will split a new one and go to it.
    if winnr != -1 
        " no need to jump if we already here
        if winnr() != winnr
            exe winnr . 'wincmd w'
        endif
    else
        " search if we have other edit window
        let i = 1
        let winCounts = winnr('$')
        while i <= winCounts
            if !ex#window#is_plugin_window(i)
                exe i . 'wincmd w'
                return
            endif
            let i = i + 1
        endwhile

        " split a new one and go to it 
        exec 'rightbelow vsplit' 
        exec 'enew' 
        let newBuf = bufnr('%') 
        set buflisted 
        set bufhidden=delete 
        set buftype=nofile 
        setlocal noswapfile 
        normal athis is the scratch buffer 
    endif
endfunction

" ex#window#goto_plugin_window {{{
function ex#window#goto_plugin_window()
    " get winnr from bufnr
    let winnr = bufwinnr(s:last_editplugin_bufnr)

    if winnr != -1 && winnr() != winnr
        exe winnr . 'wincmd w'
    endif
endfunction

" ex#window#switch_window {{{
function ex#window#switch_window()
    if ex#window#is_plugin_window(winnr())
        call ex#window#goto_edit_window()
    else
        call ex#window#goto_plugin_window()
    endif
endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
