" default configuration {{{1
if !exists('g:ex_qfix_winsize')
    let g:ex_qfix_winsize = 10
endif

if !exists('g:ex_qfix_winsize_zoom')
    let g:ex_qfix_winsize_zoom = 20
endif

" bottom or top
if !exists('g:ex_qfix_winpos')
    let g:ex_qfix_winpos = 'bottom'
endif

if !exists('g:ex_qfix_enable_help')
    let g:ex_qfix_enable_help = 1
endif

"}}}

" commands {{{1
command! -n=? -complete=file QFix call exqfix#open('<args>')
command! EXQFixOpen call exqfix#open_window()
command! EXQFixClose call exqfix#close_window()
command! EXQFixToggle call exqfix#toggle_window()
command! EXQFixPaste call exqfix#paste('*')
"}}}

" default key mappings {{{1
call exqfix#register_hotkey( 1  , 1, '<F1>'            , ":call exqfix#toggle_help()<CR>"                        , 'Toggle help.' )
if has('gui_running')
    call exqfix#register_hotkey( 2  , 1, '<ESC>'           , ":call exqfix#close_window()<CR>"                       , 'Close window.' )
else
    call exqfix#register_hotkey( 2  , 1, '<leader><ESC>'   , ":call exqfix#close_window()<CR>"                       , 'Close window.' )
endif
call exqfix#register_hotkey( 3  , 1, '<Space>'         , ":call exqfix#toggle_zoom()<CR>"                        , 'Zoom in/out project window.' )
call exqfix#register_hotkey( 4  , 1, '<CR>'            , ":call exqfix#confirm_select('')<CR>"                   , 'File: Open it. Folder: Fold in/out.' )
call exqfix#register_hotkey( 5  , 1, '<2-LeftMouse>'   , ":call exqfix#confirm_select('')<CR>"                   , 'File: Open it. Folder: Fold in/out.' )
call exqfix#register_hotkey( 6  , 1, '<S-CR>'          , ":call exqfix#confirm_select('shift')<CR>"              , 'File: Split and open it. Folder: Open the folder in os file browser.' )
call exqfix#register_hotkey( 7  , 1, '<S-2-LeftMouse>' , ":call exqfix#confirm_select('shift')<CR>"              , 'File: Split and open it. Folder: Open the folder in os file browser.' )
call exqfix#register_hotkey( 8  , 1, 'p'               , ":call exqfix#paste('" . '"' . "')<CR>"                 , 'Paste error list from register ".' )
call exqfix#register_hotkey( 9  , 1, '<leader>p'       , ":call exqfix#paste('*')<CR>"                           , 'Paste error list from register *.' )
"}}}

call ex#register_plugin( 'exqfix', { 'actions': ['autoclose'] } )

" vim:ts=4:sw=4:sts=4 et fdm=marker:
