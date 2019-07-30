" default configuration {{{1
if !exists('g:ex_cscope_winsize')
    let g:ex_cscope_winsize = 20
endif

if !exists('g:ex_cscope_winsize_zoom')
    let g:ex_cscope_winsize_zoom = 40
endif

" bottom or top
if !exists('g:ex_cscope_winpos')
    let g:ex_cscope_winpos = 'bottom'
endif

if !exists('g:ex_cscope_ignore_case')
    let g:ex_cscope_ignore_case = 1
endif

if !exists('g:ex_cscope_enable_help')
    let g:ex_cscope_enable_help = 1
endif

" commands {{{1
command! -n=1 -complete=customlist,ex#compl_by_symbol CSelect call excscope#select('<args>')
command! EXCScopeCWord call excscope#select(expand('<cword>'))

command! EXCSToggle call excscope#toggle_window()
command! EXCSOpen call excscope#open_window()
command! EXCSClose call excscope#close_window()
command! EXCSParseFunction call excscope#parse_function()

"/////////////////////////////////////////////////////////////////////////////
" Commands
"/////////////////////////////////////////////////////////////////////////////

command! -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSD call excscope#get_searchresult('<args>', 'da')
command! -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSC call excscope#get_searchresult('<args>', 'c')
command! -nargs=1 -complete=customlist,exUtility#CompleteByProjectFile CSI call excscope#get_searchresult('<args>', 'i')
command! -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSS call excscope#get_searchresult('<args>', 's')
command! -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSG call excscope#get_searchresult('<args>', 'g')
command! -nargs=1 -complete=customlist,exUtility#CompleteBySymbolFile CSE call excscope#get_searchresult('<args>', 'e')


command! CSDD call excscope#go_direct('da') " Find functions called by this function
command! CSCD call excscope#go_direct('c') " Find functions calling this function
command! CSID call excscope#go_direct('i') " Find files #including this file
command! CSIC call excscope#get_searchresult(fnamemodify( bufname("%"), ":p:t" ), 'i')
command! CSSD call excscope#go_direct('s') " Find this C symbol
command! CSGD call excscope#go_direct('g') " Find this definition
command! CSED call excscope#go_direct('e') " Find this egrep pattern


"}}}

" default key mappings {{{1
call excscope#register_hotkey( 1  , 1, '<F1>'            , ":call excscope#toggle_help()<CR>"           , 'Toggle help.' )
if has('gui_running')
    call excscope#register_hotkey( 2  , 1, '<ESC>'           , ":EXCSClose<CR>"                         , 'Close window.' )
else
    call excscope#register_hotkey( 2  , 1, '<leader><ESC>'   , ":EXCSClose<CR>"                         , 'Close window.' )
endif
call excscope#register_hotkey( 3  , 1, '<Space>'         , ":call excscope#toggle_zoom()<CR>"           , 'Zoom in/out project window.' )
call excscope#register_hotkey( 4  , 1, '<CR>'            , ":call excscope#confirm_select('')<CR>"      , 'Go to the select result.' )
call excscope#register_hotkey( 5  , 1, '<2-LeftMouse>'   , ":call excscope#confirm_select('')<CR>"      , 'Go to the select result.' )
call excscope#register_hotkey( 6  , 1, '<S-CR>'          , ":call excscope#confirm_select('shift')<CR>" , 'Go to the select result in split window.' )
call excscope#register_hotkey( 7  , 1, '<S-2-LeftMouse>' , ":call excscope#confirm_select('shift')<CR>" , 'Go to the select result in split window.' )
"}}}

call ex#register_plugin( 'excscope', { 'actions': ['autoclose'] } )

" vim:ts=4:sw=4:sts=4 et fdm=marker:
