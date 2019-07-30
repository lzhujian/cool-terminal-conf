" default configuration {{{1
if !exists('g:ex_hierarchy_winsize')
    let g:ex_hierarchy_winsize = 20
endif

if !exists('g:ex_hierarchy_winsize_zoom')
    let g:ex_hierarchy_winsize_zoom = 40
endif

" bottom or top
if !exists('g:ex_hierarchy_winpos')
    let g:ex_hierarchy_winpos = 'bottom'
endif

if !exists('g:ex_hierarchy_ignore_case')
    let g:ex_hierarchy_ignore_case = 1
endif

if !exists('g:ex_hierarchy_enable_sort')
    let g:ex_hierarchy_enable_sort = 1
endif

" will not sort the result if result lines more than x 
if !exists('g:ex_hierarchy_sort_lines_threshold')
    let g:ex_hierarchy_sort_lines_threshold = 100
endif

if !exists('g:ex_hierarchy_enable_help')
    let g:ex_hierarchy_enable_help = 1
endif

"}}}

" commands {{{1
command! -n=1 -complete=customlist,ex#compl_by_symbol HV call exhierarchy#view('<args>', 'all')
command! -n=1 -complete=customlist,ex#compl_by_symbol HVP call exhierarchy#view('<args>', 'parent')
command! -n=1 -complete=customlist,ex#compl_by_symbol HVC call exhierarchy#view('<args>', 'children')
command! EXHierarchyCWord call exhierarchy#view(expand('<cword>'), 'all')

command! EXHierarchyToggle call exhierarchy#toggle_window()
command! EXHierarchyOpen call exhierarchy#open_window()
command! EXHierarchyClose call exhierarchy#close_window()
"}}}

" default key mappings {{{1
call exhierarchy#register_hotkey( 1 , 1, '<F1>'            , ":call exhierarchy#toggle_help()<CR>"           , 'Toggle help.' )
if has('gui_running')
    call exhierarchy#register_hotkey( 2 , 1, '<ESC>'           , ":EXHierarchyClose<CR>"                         , 'Close window.' )
else
    call exhierarchy#register_hotkey( 2 , 1, '<leader><ESC>'   , ":EXHierarchyClose<CR>"                         , 'Close window.' )
endif
call exhierarchy#register_hotkey( 3 , 1, '<Space>'         , ":call exhierarchy#toggle_zoom()<CR>"           , 'Zoom in/out project window.' )
call exhierarchy#register_hotkey( 4 , 1, '<CR>'            , ":call exhierarchy#confirm_select('')<CR>"      , 'Go to the search result.' )
call exhierarchy#register_hotkey( 5 , 1, '<2-LeftMouse>'   , ":call exhierarchy#confirm_select('')<CR>"      , 'Go to the search result.' )
call exhierarchy#register_hotkey( 6 , 1, '<S-CR>'          , ":call exhierarchy#confirm_select('shift')<CR>" , 'Go to the search result in split window.' )
call exhierarchy#register_hotkey( 7 , 1, '<S-2-LeftMouse>' , ":call exhierarchy#confirm_select('shift')<CR>" , 'Go to the search result in split window.' )
"}}}

call ex#register_plugin( 'exhierarchy', { 'actions': ['autoclose'] } )

" vim:ts=4:sw=4:sts=4 et fdm=marker:
