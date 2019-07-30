let s:old_titlestring=&titlestring
let s:old_tagrelative=&tagrelative
let s:old_tags=&tags

" exconfig#apply_project_type {{{
function exconfig#apply_project_type()
endfunction

" exconfig#reset {{{
function exconfig#reset()
    let &titlestring=s:old_titlestring
    let &tagrelative=s:old_tagrelative
    let &tags=s:old_tags
endfunction

" exconfig#edit {{{
function exconfig#edit_cur_vimentry()
    let project_name = vimentry#get('project_name')
    let project_cwd = g:exvim_project_root
    if project_name == ''
        call ex#error("Can't find vimentry setting 'project_name'.")
        return
    endif
    if  findfile( project_name.'.exvim', escape(project_cwd,' \') ) != ""
        let vimentry_file = project_name . '.exvim'
        call ex#hint( 'edit vimentry file: ' . vimentry_file )
        call ex#window#goto_edit_window()
        silent exec 'e ' . project_cwd . '/' . vimentry_file
    else
        call ex#warning("can't find current vimentry file")
    endif
endfunction

" exconfig#apply {{{
function exconfig#apply()

    " ===================================
    " pre-check
    " ===================================

    let project_name = vimentry#get('project_name')
    if project_name == ''
        call ex#error("Can't find vimentry setting 'project_name'.")
        return
    endif

    " NOTE: we use the dir path of .vimentry instead of getcwd().
    " getcwd
    let filename = expand('%')
    let cwd = ex#path#translate( fnamemodify( filename, ':p:h' ), 'unix' )

    let g:exvim_project_name = project_name
    let g:exvim_project_root = cwd
    let g:exvim_folder = './.exvim.'.project_name

    " set parent working directory
    silent exec 'cd ' . fnameescape(cwd)
    let g:exvim_project_name = project_name

    let s:old_titlestring=&titlestring
    set titlestring=%{g:exvim_project_name}:\ %t\ (%{expand(\"%:p:.:h\")}/)

    " create folder .exvim.xxx/ if not exists
    let path = g:exvim_folder
    if finddir(path) == ''
        silent call mkdir(path)
    endif

    " create folder .exvim.xxx/view/ if not exists, and set viewdir to it
    let path = g:exvim_folder.'/view'
    if finddir(path) == ''
        silent call mkdir(path)
    endif
    let &viewdir = g:exvim_folder . '/view'

    " ===================================
    " general settings
    " ===================================

    " apply project_type settings
    if !vimentry#check('project_type', '')
        " TODO:
        " let project_types = split( vimentry#get('project_type'), ',' )
    endif

    " Editing
    let indent_stop=str2nr(vimentry#get('indent'))
    let &tabstop=indent_stop
    let &shiftwidth=indent_stop

    let expand_tab = vimentry#get('expand_tab')
    let &expandtab = (expand_tab == "true" ? 1 : 0)

    if exists ( ':IndentLinesReset' )
        exec 'IndentLinesReset '.indent_stop
    endif

    " Building
    let builder = vimentry#get('builder')
    let build_opt = vimentry#get('build_opt')
    call exqfix#set_compiler(builder)
    call exqfix#set_qfix_file(g:exvim_folder.'/errors.qfix')

    if maparg('<leader>bb','n') != ""
        nunmap <leader>bb
    endif
    let build_cmd = ":call exqfix#build('".build_opt."')<CR>"
    call exqfix#register_hotkey( 99, 0, '<leader>bb', build_cmd, 'Build project and get errors.' )

    " set tag file path
    if vimentry#check('enable_tags', 'true')
        let s:old_tagrelative=&tagrelative
        let &tagrelative=0 " set notagrelative

        let s:old_tags=&tags
        let &tags=fnameescape(s:old_tags.','.g:exvim_folder.'/tags')

        call exconfig#gen_sh_update_files(g:exvim_folder)
        call exconfig#gen_sh_update_ctags(g:exvim_folder)

        " symbols
        if vimentry#check('enable_symbols', 'true')
            call exsymbol#set_file(g:exvim_folder.'/symbols')
            call ex#set_symbol_path(g:exvim_folder.'/symbols')
            call exconfig#gen_sh_update_symbols(g:exvim_folder)
        endif

        " create .exvim.xxx/hierarchies/
        if vimentry#check('enable_inherits', 'true')
            call exhierarchy#set_inheirts_file(g:exvim_folder.'/inherits')
            call exhierarchy#set_dot_file(g:exvim_folder.'/hv.dot')
            call exhierarchy#set_img_file(g:exvim_folder.'/hv.png')
            call exconfig#gen_sh_update_inherits(g:exvim_folder)
        endif
    endif

    " set gsearch
    if vimentry#check('enable_gsearch', 'true')
        let gsearch_engine = vimentry#get('gsearch_engine')
        if gsearch_engine == 'idutils'
            call exgsearch#set_id_file(g:exvim_folder.'/ID')
            call exconfig#gen_sh_update_idutils(g:exvim_folder)
        endif
    endif

    " set cscope file path
    if vimentry#check('enable_cscope', 'true')
        call excscope#set_csfile(g:exvim_folder.'/cscope.out')
        call exconfig#gen_sh_update_cscope(g:exvim_folder)
        call excscope#connect()
    endif

    " macro highlight
    if vimentry#check('enable_macrohl', 'true')
        " TODO: silent call g:exMH_InitMacroList(g:exES_Macro)
    endif

    " buffer restore
    if vimentry#check('enable_restore_bufs', 'true')
        call ex#set_restore_info(g:exvim_folder.'/restore_info')

        augroup ex_restore_info
            au! VimLeave * call ex#save_restore_info ()
        augroup END
    else
        augroup ex_restore_info
            au!
        augroup END
    endif

    " custom ctrlp ignores
    let file_pattern = ''
    " let file_suffixs = vimentry#get('file_filter',[])
    " if len(file_suffixs) > 0
    "     for suffix in file_suffixs
    "         let file_pattern .= suffix . '|'
    "     endfor
    "     let file_pattern = '\v\.(' . file_pattern , ')$'
    " endif

    let dir_pattern = ''
    if vimentry#check( 'folder_filter_mode',  'exclude' )
        let folders = vimentry#get('folder_filter',[])
        if len(folders) > 0
            for folder in folders
                let dir_pattern .= folder . '|'
            endfor
            let dir_pattern = strpart( dir_pattern, 0, len(dir_pattern) - 1)

            let dir_pattern = '\v[\/](' . dir_pattern . ')$'
        endif
    endif

    let g:ctrlp_custom_ignore = {
                \ 'dir': dir_pattern,
                \ 'file': file_pattern,
                \ }


    " TODO:
    " " set vimentry references
    " if !vimentry#check('sub_vimentry', '')
    "   for vimentry in g:exES_vimentryRefs
    "     let ref_entry_dir = fnamemodify( vimentry, ':p:h')
    "     let ref_vimfiles_dirname = '.vimfiles.' . fnamemodify( vimentry, ":t:r" )
    "     let fullpath_tagfile = exUtility#GetVimFile ( ref_entry_dir, ref_vimfiles_dirname, 'tag')
    "     if has ('win32')
    "       let fullpath_tagfile = exUtility#Pathfmt( fullpath_tagfile, 'windows' )
    "     elseif has ('unix')
    "       let fullpath_tagfile = exUtility#Pathfmt( fullpath_tagfile, 'unix' )
    "     endif
    "     if findfile ( fullpath_tagfile ) != ''
    "       let &tags .= ',' . fullpath_tagfile
    "     endif
    "   endfor
    " endif

    " ===================================
    " layout windows
    " ===================================

    " open project window
    if vimentry#check('enable_project_browser', 'true')
        let project_browser = vimentry#get( 'project_browser' )
        let g:ex_project_file = g:exvim_folder . "/files.exproject"

        " NOTE: Any windows open or close during VimEnter will not invoke WinEnter,WinLeave event
        " this is why I manually call doautocmd here
        if project_browser == 'ex'
            if exists ( ':NERDTreeClose' )
                exec 'NERDTreeClose'
            endif

            " open ex_project window
            doautocmd BufLeave
            doautocmd WinLeave

            silent call exproject#set_file_filters( vimentry#get('file_filter',[]) )
            silent call exproject#set_file_ignore_patterns( vimentry#get('file_ignore_pattern',[]) )
            silent call exproject#set_folder_filters( vimentry#get('folder_filter',[]) )
            silent call exproject#set_folder_filter_mode( vimentry#get('folder_filter_mode','include') )

            silent exec 'EXProject ' . fnameescape(g:ex_project_file)

            " TODO: add dirty message in ex-project window and hint user to press \R for refresh

            " bind key mapping
            if maparg('<leader>fc','n') != ""
                nunmap <leader>fc
            endif
            call exproject#register_hotkey( 100, 0, '<leader>fc', ":EXProjectFind<CR>", 'Find current edit buffer in project window.' )

            if has('gui_running')
                if has ('mac')
                    if maparg('Ø','n') != ""
                        nunmap Ø
                    endif
                    call exproject#register_hotkey( 101, 0, 'Ø', ":EXProjectOpen<CR>:redraw<CR>/", 'Open project window and stay in search mode.' )
                else
                    if maparg('<M-O>','n') != ""
                        nunmap <M-O>
                    endif
                    call exproject#register_hotkey( 101, 0, '<M-O>', ":EXProjectOpen<CR>:redraw<CR>/", 'Open project window and stay in search mode.' )
                endif
            endif

            " back to edit window
            doautocmd BufLeave
            doautocmd WinLeave
            call ex#window#goto_edit_window()

        elseif project_browser == 'nerdtree'
            if exists ( ':EXProjectClose' )
                exec 'EXProjectClose'
            endif

            " Example: let g:NERDTreeIgnore=['.git$[[dir]]', '.o$[[file]]']
            let g:NERDTreeIgnore = [] " clear ignore list
            let file_ignore_pattern = vimentry#get('file_ignore_pattern')
            if type(file_ignore_pattern) == type([])
                for pattern in file_ignore_pattern
                    silent call add ( g:NERDTreeIgnore, pattern.'[[file]]' )
                endfor
            endif

            if vimentry#check( 'folder_filter_mode',  'exclude' )
                let folder_filter = vimentry#get('folder_filter')
                if type(folder_filter) == type([])
                    for pattern in folder_filter
                        silent call add ( g:NERDTreeIgnore, pattern.'[[dir]]' )
                    endfor
                endif
            endif

            " bind key mapping
            if maparg('<leader>fc','n') != ""
                nunmap <leader>fc
            endif
            nnoremap <unique> <leader>fc :NERDTreeFind<CR>

            if has('gui_running') "  the <alt> key is only available in gui mode.
                if has ('mac')
                    if maparg('Ø','n') != ""
                        nunmap Ø
                    endif
                    nnoremap <unique> Ø :NERDTreeFind<CR>:redraw<CR>/
                else
                    if maparg('<M-O>','n') != ""
                        nunmap <M-O>
                    endif
                    nnoremap <unique> <M-O> :NERDTreeFind<CR>:redraw<CR>/
                endif
            endif

            " open nerdtree window
            doautocmd BufLeave
            doautocmd WinLeave
            silent exec 'NERDTree'

            " back to edit window
            doautocmd BufLeave
            doautocmd WinLeave
            call ex#window#goto_edit_window()
        endif
    endif

    " ===================================
    " post
    " ===================================

    " do buffer restore
    if vimentry#check('enable_restore_bufs', 'true')
        if vimentry#is_first_time()
            call ex#restore_lasteditbuffers()
        endif
    endif

    " run customized scripts
    if exists('*g:exvim_post_init')
        call g:exvim_post_init()
    endif
endfunction

" exconfig#gen_sh_update_files {{{
function exconfig#gen_sh_update_files(path)
    " generate scripts
    if ex#os#is('windows')
        " check if gawk command executable
        if !executable('gawk')
            call ex#warning("Can't find gawk command in your system. Please install it first!")
        endif

        let gawk_suffix = 'exc'
        if vimentry#check('folder_filter_mode', 'include')
            let gawk_suffix = 'inc'
        endif

        let folder_filter = vimentry#get('folder_filter', [])
        let folder_pattern_gawk = ''
        if !empty(folder_filter)
            for name in folder_filter
                let folder_pattern_gawk .= '.*\\\\'.name.'\\\\.*|'
            endfor
            let folder_pattern_gawk = strpart( folder_pattern_gawk, 0, len(folder_pattern_gawk) - 1)
        endif

        let file_pattern = ''
        let file_pattern_gawk = ''
        let file_filters = vimentry#get('file_filter', [])
        if !empty(file_filters)
            for name in file_filters
                let file_pattern .= '*.' . toupper(name) . ' '
                let file_pattern_gawk .= '\\\\.' . name . '$|'
            endfor
            let file_pattern = strpart( file_pattern, 0, len(file_pattern) - 1)
            let file_pattern_gawk = strpart( file_pattern_gawk, 0, len(file_pattern_gawk) - 1)
        endif

        let fullpath = a:path . '/update-filelist.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                           ,
                    \ 'set DEST='.winpath                                   ,
                    \ 'set TOOLS='.wintoolpath                              ,
                    \ 'set FILE_SUFFIXS='.file_pattern                      ,
                    \ 'set GAWK_SUFFIX='.gawk_suffix                        ,
                    \ 'set FILE_FILTER_PATTERN="'.file_pattern_gawk.'"'     ,
                    \ 'set FOLDER_FILTER_PATTERN="'.folder_pattern_gawk.'"' ,
                    \ 'set TMP=%DEST%\_files_gawk'                          ,
                    \ 'set TMP2=%DEST%\_files'                              ,
                    \ 'set TARGET=%DEST%\files'                             ,
                    \ 'set ID_TARGET="%DEST%\idutils-files"'                ,
                    \ 'call %TOOLS%\shell\batch\update-filelist.bat'        ,
                    \ ]
    else
        " DISABLE
        " let gawk_suffix = 'exc'
        " if vimentry#check('folder_filter_mode', 'include')
        "     let gawk_suffix = 'inc'
        " endif
        " let folder_pattern_gawk = ''
        " if !empty(folder_filter)
        "     for name in folder_filter
        "         let folder_pattern_gawk .= '.*\\\/'.name.'\\\/.*|'
        "     endfor
        "     let folder_pattern_gawk = strpart( folder_pattern_gawk, 0, len(folder_pattern_gawk) - 1)
        " endif
        " let file_pattern_gawk = ''
        " if !empty(file_filters)
        "     for name in file_filters
        "         let file_pattern_gawk .= '\\\\.' . name . '$|'
        "     endfor
        "     let file_pattern_gawk = strpart( file_pattern_gawk, 0, len(file_pattern_gawk) - 1)
        " endif
        " \ 'export GAWK_SUFFIX='.gawk_suffix                         ,
        " \ 'export FILE_FILTER_PATTERN="'.file_pattern_gawk.'"'      ,
        " \ 'export FOLDER_FILTER_PATTERN="'.folder_pattern_gawk.'"'  ,

        let exclude = '-not'
        if vimentry#check('folder_filter_mode', 'include')
            let exclude = ''
        endif

        let folder_filter = vimentry#get('folder_filter', [])
        let folder_pattern = ''
        if !empty(folder_filter)
            for name in folder_filter
                let folder_pattern .= substitute(name, "\+", "\\\\+", "g") . '|'
            endfor
            let folder_pattern = strpart( folder_pattern, 0, len(folder_pattern) - 1)
        endif

        let file_pattern = '.*'
        let file_filters = vimentry#get('file_filter', [])
        if !empty(file_filters)
            let file_pattern = ''
            for name in file_filters
                let file_pattern .= name . '|'
            endfor
            let file_pattern = strpart( file_pattern, 0, len(file_pattern) - 1)
        endif

        let fullpath = a:path . '/update-filelist.sh'
        let scripts = [
                    \ '#!/bin/bash'                                ,
                    \ 'export DEST="'.a:path.'"'                   ,
                    \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                    \ 'export IS_EXCLUDE='.exclude                 ,
                    \ 'export FOLDERS="'.folder_pattern.'"'        ,
                    \ 'export FILE_SUFFIXS="'.file_pattern.'"'     ,
                    \ 'export TMP="${DEST}/_files"'                ,
                    \ 'export TARGET="${DEST}/files"'              ,
                    \ 'export ID_TARGET="${DEST}/idutils-files"'   ,
                    \ 'bash ${TOOLS}/shell/bash/update-filelist.sh'  ,
                    \ ]
    endif

    " save to file
    call writefile ( scripts, fullpath )
endfunction

" exconfig#gen_sh_update_ctags {{{
function exconfig#gen_sh_update_ctags(path)
    " get ctags cmd
    let ctags_cmd = 'ctags'
    if executable('ctags')
        let ctags_cmd = 'ctags'
    elseif executable('exuberant-ctags')
        " On Debian Linux, exuberant ctags is installed as exuberant-ctags
        let ctags_cmd = 'exuberant-ctags'
    elseif executable('exctags')
        " On Free-BSD, exuberant ctags is installed as exctags
        let ctags_cmd = 'exctags'
    elseif executable('ctags.exe')
        let ctags_cmd = 'ctags.exe'
    elseif executable('tags')
        let ctags_cmd = 'tags'
    else
        call ex#warning("Can't find ctags command in your system. Please install it first!")
    endif

    " get ctags options
    let ctags_optioins = '--fields=+iaS --extra=+q'

    " generate scripts
    if ex#os#is('windows')
        let fullpath = a:path . '/update-tags.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                ,
                    \ 'set DEST='.winpath                        ,
                    \ 'set TOOLS='.wintoolpath                   ,
                    \ 'set CTAGS_CMD='.ctags_cmd                 ,
                    \ 'set OPTIONS='.ctags_optioins              ,
                    \ 'set TMP=%DEST%\_tags'                     ,
                    \ 'set TARGET=%DEST%\tags'                   ,
                    \ 'call %TOOLS%\shell\batch\update-tags.bat' ,
                    \ ]
    else
        if vimentry#check('enable_custom_tags', 'true')
            let fullpath = a:path . '/update-tags.sh'
            let sourcepath = vimentry#get('custom_tags_file')
            let scripts = [
                        \ '#!/bin/bash'                                 ,
                        \ 'export DEST="'.a:path.'"'                    ,
                        \ 'export TARGET="${DEST}/tags"'                ,
                        \ 'export SOURCE="'.sourcepath.'"'              ,
                        \ 'export TOOLS="'.expand(g:ex_tools_path).'"'  ,
                        \ 'export CUSTOM=true'                          ,
                        \ 'sh ${TOOLS}/shell/bash/update-tags.sh'       ,
                        \ ]
        else
            let fullpath = a:path . '/update-tags.sh'
            let scripts = [
                        \ '#!/bin/bash'                                ,
                        \ 'export DEST="'.a:path.'"'                   ,
                        \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                        \ 'export CTAGS_CMD="'.ctags_cmd.'"'           ,
                        \ 'export OPTIONS="'.ctags_optioins.'"'        ,
                        \ 'export TMP="${DEST}/_tags"'                 ,
                        \ 'export TARGET="${DEST}/tags"'               ,
                        \ 'sh ${TOOLS}/shell/bash/update-tags.sh'      ,
                        \ ]
        endif
    endif

    " save to file
    call writefile ( scripts, fullpath )
endfunction

" --------------------------------------------------
" echo "  |- generate cscope.out"
" cscope -kb -i cscope.files
" # cscope -b
" if [ -f "./cscope.files" ]; then
" echo "  |- move cscope.files to ./${vimfiles_path}/cscope.files"
" mv -f "cscope.files" "./${vimfiles_path}/cscope.files"
" fi
" if [ -f "./cscope.out" ]; then
" echo "  |- move cscope.out to ./${vimfiles_path}/cscope.out"
" mv -f "cscope.out" "./${vimfiles_path}/cscope.out"
" fi
" echo "  |- done!"
" --------------------------------------------------

" exconfig#gen_sh_update_cscope {{{
function exconfig#gen_sh_update_cscope(path)
    " get cscope cmd
    let cscope_cmd = 'cscope'
    if executable('cscope')
        let cscope_cmd = 'cscope'
    else
        call ex#warning("Can't find cscope command in your system. Please install it first!")
    endif

    " get cscope options
    let cscope_optioins = '-kb -i'

    " generate scripts
    if ex#os#is('windows')
        let fullpath = a:path . '/update-cscope.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                  ,
                    \ 'set DEST='.winpath                          ,
                    \ 'set TOOLS='.wintoolpath                     ,
                    \ 'set CSCOPE_CMD='.cscope_cmd                 ,
                    \ 'set OPTIONS='.cscope_optioins               ,
                    \ 'set TMP=%DEST%\_cscope.out'                 ,
                    \ 'set TARGET=%DEST%\cscope.out'               ,
                    \ 'call %TOOLS%\shell\batch\update-cscope.bat' ,
                    \ ]
    else
        let fullpath = a:path . '/update-cscope.sh'
        let scripts = [
                    \ '#!/bin/bash'                                ,
                    \ 'export DEST="'.a:path.'"'                   ,
                    \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                    \ 'export CSCOPE_CMD="'.cscope_cmd.'"'         ,
                    \ 'export OPTIONS="'.cscope_optioins.'"'       ,
                    \ 'export TMP="${DEST}/_cscope.out"'           ,
                    \ 'export TARGET="${DEST}/cscope.out"'         ,
                    \ 'sh ${TOOLS}/shell/bash/update-cscope.sh'    ,
                    \ ]
    endif

    " save to file
    call writefile ( scripts, fullpath )
endfunction

" exconfig#gen_sh_update_symbols {{{
function exconfig#gen_sh_update_symbols(path)
    " check if gawk command executable
    if !executable('gawk')
        call ex#warning("Can't find gawk command in your system. Please install it first!")
    endif

    " generate scripts
    if ex#os#is('windows')
        let fullpath = a:path . '/update-symbols.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                   ,
                    \ 'set DEST='.winpath                           ,
                    \ 'set TOOLS='.wintoolpath                      ,
                    \ 'set TMP=%DEST%\_symbols'                     ,
                    \ 'set TARGET=%DEST%\symbols'                   ,
                    \ 'call %TOOLS%\shell\batch\update-symbols.bat' ,
                    \ ]
    else
        let fullpath = a:path . '/update-symbols.sh'
        let scripts = [
                    \ '#!/bin/bash'                                ,
                    \ 'export DEST="'.a:path.'"'                   ,
                    \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                    \ 'export TMP="${DEST}/_symbols"'              ,
                    \ 'export TARGET="${DEST}/symbols"'            ,
                    \ 'sh ${TOOLS}/shell/bash/update-symbols.sh'   ,
                    \ ]
    endif

    " save to file
    call writefile ( scripts, fullpath )
endfunction

" exconfig#gen_sh_update_inherits {{{
function exconfig#gen_sh_update_inherits(path)
    " check if gawk command executable
    if !executable('gawk')
        call ex#warning("Can't find gawk command in your system. Please install it first!")
    endif

    " generate scripts
    if ex#os#is('windows')
        let fullpath = a:path . '/update-inherits.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                    ,
                    \ 'set DEST='.winpath                            ,
                    \ 'set TOOLS='.wintoolpath                       ,
                    \ 'set TMP=%DEST%\_inherits'                     ,
                    \ 'set TARGET=%DEST%\inherits'                   ,
                    \ 'call %TOOLS%\shell\batch\update-inherits.bat' ,
                    \ ]
    else
        let fullpath = a:path . '/update-inherits.sh'
        let scripts = [
                    \ '#!/bin/bash'                                ,
                    \ 'export DEST="'.a:path.'"'                   ,
                    \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                    \ 'export TMP="${DEST}/_inherits"'             ,
                    \ 'export TARGET="${DEST}/inherits"'           ,
                    \ 'sh ${TOOLS}/shell/bash/update-inherits.sh'  ,
                    \ ]
    endif

    " save to file
    call writefile ( scripts, fullpath )
endfunction

" exconfig#gen_sh_update_idutils {{{
let s:default_id_file_filter = [
    \ 'h', 'h++', 'h.in', 'H', 'hh', 'hp', 'hpp', 'hxx', 'inl',
    \ 'c', 'C', 'cc', 'cp', 'cpp', 'cxx',
    \ 'cs',
    \ 'm',
    \ 'hlsl', 'vsh', 'psh', 'fx', 'fxh', 'cg', 'shd',
    \ 'asm', 'ASM', 's', 'S',
    \ 'py', 'pyx', 'pxd', 'scons',
    \ 'rb',
    \ 'js', 'as', 'ts', 'coffee',
    \ 'lua',
    \ 'ms',
    \ 'pl', 'pm',
    \ 'vim',
    \ 'html', 'htm', 'shtml', 'stm',
    \ 'css', 'sass', 'scss', 'less', 'styl',
    \ 'xml', 'mms', 'glm',
    \ 'json',
    \ 'l', 'lex', 'y', 'yacc',
    \ 'hrl', 'erl',
    \ 'php',
    \ 'rs',
    \ 'go',
    \ ]

function exconfig#gen_sh_update_idutils(path)
    " check if mkid command executable
    if !executable('mkid')
        call ex#warning("Can't find mkid command in your system. Please install it first!")
    endif

    " generate scripts
    if ex#os#is('windows')

        " TODO: DELME { currently exconfig#gen_sh_update_idutils still use this
        " set folder filter to exvim_root_folders and exvim_root_exclude_folders
        let folder_filter = copy(vimentry#get('folder_filter', []))
        let exvim_root_folders = []
        let exvim_root_exclude_folders = []
        let cwd = g:exvim_project_root

        if !empty(folder_filter)
            " we need search the root directory, and add folders that not excluded
            if vimentry#check('folder_filter_mode', 'exclude')
                " set include folders
                let filelist = split(globpath(cwd,'*'),'\n')
                for name in filelist
                    if isdirectory(name)
                        let name = fnamemodify(name,':t')
                        if index( folder_filter, name ) == -1
                            silent call add ( exvim_root_folders, name )
                        endif
                    endif
                endfor

                " set exclude folders
                for name in folder_filter
                    if isdirectory(name)
                        silent call add ( exvim_root_exclude_folders, name )
                    endif
                endfor
            else
                " set include folders
                for name in folder_filter
                    if isdirectory(name)
                        silent call add ( exvim_root_folders, name )
                    endif
                endfor

                " set exclude folders
                let filelist = split(globpath(cwd,'*'),'\n')
                for name in filelist
                    if isdirectory(name)
                        let name = fnamemodify(name,':t')
                        if index( folder_filter, name ) == -1
                            silent call add ( exvim_root_exclude_folders, name )
                        endif
                    endif
                endfor
            endif
        else
            let filelist = split(globpath(cwd,'*'),'\n')
            for name in filelist
                if isdirectory(name)
                    let name = fnamemodify(name,':t')
                    silent call add ( exvim_root_folders, name )
                endif
            endfor
        endif

        " get exclude folder filter options
        " NOTE: this mkid have bug that if a folder name has white space, --prune="foo bar" will treat it as two folder.
        let exclude_folders = ''
        for name in exvim_root_exclude_folders
            let exclude_folders .= name . ' '
        endfor
        if !empty(exvim_root_folders)
            let exclude_folders = strpart( exclude_folders, 0, len(exclude_folders) - 1)
        endif
        " TODO: DELME }

        let fullpath = a:path . '/update-idutils.bat'
        let winpath = ex#path#translate(a:path,'windows')
        let wintoolpath = ex#path#translate(g:ex_tools_path,'windows')
        let wintoolpath = expand(wintoolpath)
        let scripts = [
                    \ '@echo off'                                   ,
                    \ 'set DEST='.winpath                           ,
                    \ 'set TOOLS='.wintoolpath                      ,
                    \ 'set EXCLUDE_FOLDERS='.exclude_folders        ,
                    \ 'set TMP=%DEST%\_ID'                          ,
                    \ 'set TARGET=%DEST%\ID'                        ,
                    \ 'call %TOOLS%\shell\batch\update-idutils.bat' ,
                    \ ]
    else
        let fullpath = a:path . '/update-idutils.sh'
        let scripts = [
                    \ '#!/bin/bash'                                ,
                    \ 'export DEST="'.a:path.'"'                   ,
                    \ 'export TOOLS="'.expand(g:ex_tools_path).'"' ,
                    \ 'export TMP="${DEST}/_ID"'                   ,
                    \ 'export TARGET="${DEST}/ID"'                 ,
                    \ 'sh ${TOOLS}/shell/bash/update-idutils.sh'   ,
                    \ ]
    endif

    " save to file
    call writefile ( scripts, fullpath )

    " generate id-lang-autogen.map
    let fullpath = a:path . '/id-lang-autogen.map'
    if ex#os#is('windows')
        let fullpath = ex#path#translate(fullpath,'windows')
    endif
    let scripts = [
                \ '# autogen id-lang.map',
                \ '*~                    IGNORE',
                \ '*.bak                 IGNORE',
                \ '*.bk[0-9]             IGNORE',
                \ '[sp].*                IGNORE',
                \ '*/.deps/*             IGNORE',
                \ '*/.svn/*              IGNORE',
                \ '*.svn-base            IGNORE',
                \ '.git/*                IGNORE',
                \ '.exvim*/*             IGNORE',
                \ '*.err                 IGNORE',
                \ '*.exe                 IGNORE',
                \ '*.lnk                 IGNORE',
                \ '*.min.js              IGNORE',
                \ ]

    " NOTE: no used at all. id-utils can not ignore folder
    " set folder_filter exclude
    if vimentry#check('folder_filter_mode', 'exclude')
        let ignore_folders = vimentry#get('folder_filter',[])
        for item in ignore_folders
            if item == ''
                continue
            endif
            silent call add ( scripts, '*/'.item.'/*    IGNORE')
        endfor
    endif

    " set file ignore pattern
    let file_ignore_pattern = vimentry#get('file_ignore_pattern',[])
    for item in file_ignore_pattern
        if item == ''
            continue
        endif
        silent call add ( scripts, item.'    IGNORE')
    endfor

    " set file fitlers
    let file_filters = vimentry#get('file_filter',[])
    if empty(file_filters)
        let file_filters = s:default_id_file_filter
    endif
    for item in file_filters
        if item == ''
            continue
        endif
        silent call add ( scripts, '*.'.item.'    text')
    endfor

    let scriptText = join(scripts, "\n")
    if ex#os#is('windows')
        let scriptText = substitute(scriptText , '\/', '\\\\', 'g')
    endif
    " save to file
    call writefile( split(scriptText, "\n") , fullpath, 'b' )
endfunction

" exconfig#update_exvim_files {{{
function exconfig#update_exvim_files()
    if ex#os#is('windows')
        let shell_exec = 'call'
        let shell_and = ' & '
        let shell_pause = ' && pause'
        let suffix = '.bat'
        let path = '.\.exvim.'.g:exvim_project_name.'\'
    else
        let shell_exec = 'sh'
        let shell_and = ' && '
        let shell_pause = ''
        let suffix = '.sh'
        let path = './.exvim.'.g:exvim_project_name.'/'
    endif

    let cmd = ''
    let and = ''

    " update filelist, tags, symbols
    if vimentry#check('enable_tags','true')
        let cmd = shell_exec . ' ' . path.'update-filelist'.suffix
        let and = shell_and

        let cmd .= and
        let cmd .= shell_exec . ' ' . path.'update-tags'.suffix

        if vimentry#check('enable_symbols','true')
            let cmd .= and
            let cmd .= shell_exec . ' ' . path.'update-symbols'.suffix
        endif

        if vimentry#check('enable_inherits','true')
            let cmd .= and
            let cmd .= shell_exec . ' ' . path.'update-inherits'.suffix
        endif
    endif

    " update IDs
    if vimentry#check('enable_gsearch','true')
        let cmd .= and
        let cmd .= shell_exec . ' ' . path.'update-idutils'.suffix
        let and = shell_and
    endif

    " update cscope
    if vimentry#check('enable_cscope','true')
        call excscope#kill()
        let cmd .= and
        let cmd .= shell_exec . ' ' . path.'update-cscope'.suffix
        let and = shell_and
    endif

    let cmd .= shell_pause
    call ex#hint('exVim Updating...')
    exec '!' . cmd

    if vimentry#check('enable_cscope','true')
        call excscope#connect()
    endif

    call ex#hint('exVim Update Finish!')
endfunction



