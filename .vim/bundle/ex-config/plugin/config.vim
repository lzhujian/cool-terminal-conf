" variables {{{
if !exists('g:ex_todo_keyword')
    let g:ex_todo_keyword = '
                \ NOTE
                \ WARN
                \ WARN
                \ EXAMPLE
                \ TIPS
                \ REF
                \ '
endif

if !exists('g:ex_comment_lable_keyword')
    let g:ex_comment_lable_keyword = '
                \ TEMP
                \ MODIFY
                \ ADD
                \ DELME
                \ DISABLE
                \ DEBUG
                \ TEST
                \ FIXME
                \ KEEPME
                \ BUG
                \ HACK
                \ HARDCODE
                \ REFINE
                \ REFACTORY
                \ '
endif

if !exists('g:ex_lang_filter')
    let g:ex_lang_filter = {
                \ 'asm': [ 'asm', 's', 'a51' ],
                \ 'asp': [ 'asp', 'asa' ],
                \ 'awk': [ 'awk', 'gawk', 'mawk' ],
                \ 'basic': [ 'bas', 'bi', 'bb', 'pb' ],
                \ 'batch': [ 'bat' ],
                \ 'beta': [ 'bet' ],
                \ 'c': [ 'c', 'h' ],
                \ 'cobol': [ 'cbl', 'cob' ],
                \ 'cpp': [ 'c++', 'cc', 'cp', 'cpp', 'cxx', 'h', 'h++', 'hh', 'hp', 'hpp', 'hxx' ],
                \ 'csharp': [ 'cs' ],
                \ 'css': [ 'css', 'less', 'sass' ],
                \ 'doxygen': [ 'dox', 'doxygen' ],
                \ 'eiffel': [ 'e' ],
                \ 'erlang': [ 'erl', 'hrl' ],
                \ 'fortran': [ 'fo', 'ft', 'f7', 'f9', 'f95' ],
                \ 'go': [ 'go' ],
                \ 'html': [ 'htm', 'html' ],
                \ 'java': [ 'java' ],
                \ 'javascript': [ 'js' ],
                \ 'json': [ 'json' ],
                \ 'lisp': [ 'cl', 'clisp', 'el', 'l', 'lisp', 'lsp', 'ml' ],
                \ 'lua': [ 'lua' ],
                \ 'make': [ 'mak', 'mk', 'makefile' ],
                \ 'markdown': [ 'md', 'mdown', 'mkd', 'mkdn', 'markdown', 'mdwn' ],
                \ 'matlab': [ 'm' ],
                \ 'pascal': [ 'p', 'pas' ],
                \ 'perl': [ 'pl', 'pm', 'plx', 'perl' ],
                \ 'php': [ 'php', 'php3', 'phtml' ],
                \ 'python': [ 'py', 'pyx', 'pxd', 'scons' ],
                \ 'rexx': [ 'cmd', 'rexx', 'rx' ],
                \ 'ruby': [ 'rb', 'ruby' ],
                \ 'scheme': [ 'scm', 'sm', 'sch', 'scheme' ],
                \ 'sed': [ 'sed' ],
                \ 'sh': [ 'sh', 'bsh', 'bash', 'ksh', 'zsh' ],
                \ 'shader': [ 'hlsl', 'vsh', 'psh', 'fx', 'fxh', 'cg', 'shd', 'glsl' ],
                \ 'slang': [ 'sl' ],
                \ 'sml': ['sml', 'sig' ],
                \ 'sql': ['sql' ],
                \ 'swig': [ 'swg' ],
                \ 'tcl': ['tcl', 'tk', 'wish', 'itcl' ],
                \ 'vera': ['vr', 'vri', 'vrh' ],
                \ 'verilog': [ 'v' ],
                \ 'vim': [ 'vim' ],
                \ 'wiki': [ 'wiki' ],
                \ 'xml': [ 'xml' ],
                \ 'yacc': [ 'y' ],
                \ }
endif

if !exists('g:ex_project_types')
    let g:ex_project_types = {
                \ 'build': [ 'make' ],
                \ 'clang': [ 'c', 'cpp', 'csharp', 'java' ],
                \ 'data': [ 'json', 'xml' ],
                \ 'doc': [ 'doxygen', 'markdown', 'wiki' ],
                \ 'game': [ 'c', 'cpp', 'shader', 'lua' ],
                \ 'server': [ 'python', 'javascript', 'lua', 'ruby', 'c', 'cpp', 'csharp', 'go', 'java', 'sql' ],
                \ 'shell': [ 'awk', 'batch', 'sed', 'sh' ],
                \ 'web': [ 'css', 'html', 'javascript', 'json', 'xml' ],
                \ }
endif

if !exists('g:ex_tools_path')
    let g:ex_tools_path = '~/.vim/tools/'
endif
" }}}

" vimentry#on event registry {{{
call vimentry#on( 'reset', function('exconfig#reset') )
call vimentry#on( 'changed', function('exconfig#apply') )
call vimentry#on( 'project_type_changed', function('exconfig#apply_project_type') )
" }}}

" ex#register_plugin register plugins {{{
" register 3rd-plugins
call ex#register_plugin( 'minibufexpl', { 'bufname': '-MiniBufExplorer-', 'buftype': 'nofile', 'actions': ['norecord'] } )
call ex#register_plugin( 'taglist', { 'bufname': '__Tag_List__', 'buftype': 'nofile', 'actions': ['autoclose'] } )
call ex#register_plugin( 'tagbar', { 'bufname': '__TagBar__', 'buftype': 'nofile', 'actions': ['autoclose'] } )
call ex#register_plugin( 'nerdtree', { 'bufname': 'NERD_tree_\d\+', 'buftype': 'nofile' } )
call ex#register_plugin( 'undotree', { 'bufname': 'undotree_\d\+', 'buftype': 'nowrite' } )
call ex#register_plugin( 'diff', { 'bufname': 'diffpanel_\d\+', 'buftype': 'nowrite' } )
call ex#register_plugin( 'gitcommit', {} )
call ex#register_plugin( 'gundo', {} )
call ex#register_plugin( 'vimfiler', {} )
" register empty filetype 
call ex#register_plugin( '__EMPTY__', { 'bufname': '-MiniBufExplorer-' } )
" }}}

" commands {{{
command! Update call exconfig#update_exvim_files()
" }}}

" vim:ts=4:sw=4:sts=4 et fdm=marker:
