" variables {{{1
let s:varnames = []
let s:version = 13
" }}}

" functions {{{1

function s:write_default( name, default, comment )
    let val = a:default
    if exists( 's:vimentry_'.a:name )
        if type(s:vimentry_{a:name}) == type(a:default)
            let val = s:vimentry_{a:name}
        endif
    endif

    let comment = ""
    if a:comment != ""
        let comment = " -- " . a:comment
    endif

    "
    if type(val) == type([])
        let valList = ''
        for item in val
            if valList == ''
                let valList = item
            else
                let valList = valList . ',' . item
            endif
        endfor
        let line = a:name . " += " . valList . comment
        return substitute (line, '\s\+$', '', 'e') " strip whitespace
    endif

    "
    if a:default[0] == "'" && a:default[strlen(a:default)-1] == "'"
        if strlen(val) == 2
            let line = a:name . " = " . val . comment
            return substitute (line, '\s\+$', '', 'e') " strip whitespace
        endif

        let line = a:name . " = '" . val . "'" . comment
        return substitute (line, '\s\+$', '', 'e') " strip whitespace
    endif

    let line = a:name . " = " . val . comment
    return substitute (line, '\s\+$', '', 'e') " strip whitespace
endfunction

" vimentry#write_default_template {{{2
function vimentry#write_default_template()
    " clear screen
    silent 1,$d _

    let filename = expand('%')
    let projectName = fnamemodify( filename, ":t:r" )

    " the parameter will parse as let g:ex_{var} = val
    silent call append ( 0, [
                \ "-- Edit and save the file.",
                \ "-- The variables will be loaded and exists as g:ex_{var} in Vim's runtime.",
                \ "-- For example, \"foo = true\" will be \"g:ex_foo\", and the value is \"true\"",
                \ "",
                \ "-- Choose your project type",
                \ "-- Press <F5> to apply project_type for other settings",
                \ s:write_default( "project_type", "all", "{ all, build, clang, data, doc, game, server, shell, web, ... }" ),
                \ "",
                \ "-- Project Settings:",
                \ "version = " . s:version,
                \ "project_name = '" . projectName . "'",
                \ "",
                \ "-- File And Folder Filters:",
                \ s:write_default( "folder_filter_mode", "include", "{ include, exclude }" ),
                \ s:write_default( "folder_filter", [], "" ),
                \ s:write_default( "file_filter", [], "" ),
                \ s:write_default( "file_ignore_pattern", [], "" ),
                \ "",
                \ "-- Editing:",
                \ s:write_default( "indent", &tabstop, "" ),
                \ s:write_default( "expand_tab", (&expandtab == 0 ? "false" : "true"), "{ true, false }"),
                \ "",
                \ "-- Building:",
                \ s:write_default( "builder", "gulp", "{ gulp, grunt, gcc, xcode, vs, unity3d, ... }" ),
                \ s:write_default( "build_opt", "''", "" ),
                \ "",
                \ "-- ex-project Options:",
                \ s:write_default( "enable_project_browser", "true", "{ true, false }" ),
                \ s:write_default( "project_browser", "ex", "{ ex, nerdtree }" ),
                \ "",
                \ "-- ex-gsearch Options:",
                \ s:write_default( "enable_gsearch", "true", "{ true, false }" ),
                \ s:write_default( "gsearch_engine", "idutils", "{ idutils, grep }" ),
                \ "",
                \ "-- ex-tags Options:",
                \ s:write_default( "enable_tags", "true", "{ true, false }" ),
                \ s:write_default( "enable_symbols", "true", "{ true, false }" ),
                \ s:write_default( "enable_inherits", "true", "{ true, false }" ),
                \ s:write_default( "enable_custom_tags", "false", "{ true, false }" ),
                \ s:write_default( "custom_tags_file" , "", "" ),
                \ "",
                \ "-- ex-cscope Options:",
                \ s:write_default( "enable_cscope", "false", "{ true, false }" ),
                \ "",
                \ "-- ex-macrohl Options:",
                \ s:write_default( "enable_macrohl", "false", "{ true, false }" ),
                \ "",
                \ "-- restore buffers:",
                \ s:write_default( "enable_restore_bufs", "false", "{ true, false }" ),
                \ "",
                \ "-- Project References:",
                \ "-- sub_project_refs += foobar1.exvim -- example",
                \ "-- sub_project_refs += foobar2.exvim -- example",
                \ ] )

    " NOTE: this will not invoke 'au BufWritePost' in ftdetect/vimentry.vim
    silent exec "w!"
    silent exec "normal gg"
endfunction

" vimentry#get {{{2
function vimentry#get( name, ... )
    if exists( 's:vimentry_'.a:name )
        return s:vimentry_{a:name}
    endif

    " if we provide default, return it
    if a:0 > 0
        return a:1
    endif

    " return empty
    return ''
endfunction

" vimentry#check {{{2
function vimentry#check( name, val )
    let val = vimentry#get(a:name)
    if val == a:val
        return 1
    endif
    return 0
endfunction

" vimentry#clear_vars {{{2
function vimentry#clear_vars()
    " remove old global variables
    for varname in s:varnames
        unlet {varname}
    endfor
    let s:varnames = [] " list clean
endfunction

" vimentry#parse {{{2
function vimentry#parse()
    call vimentry#clear_vars()

    " parse each line to get variable
    for line in getline(1,'$')
        let pos = match(line,'^\w\+\s*\(+=\|=\)\s*\S*')
        if pos == -1 " if the line is comment line, skip it.
            continue
        endif

        let var = matchstr( line, '^\w\+\(\s*\(+=\|=\)\)\@=', 0 )

        " get value
        if match( line, "^\\w\\+\\s*\\(+=\\|=\\)\\s*'" ) != -1
            let val = matchstr( line, "\\(\\(+=\\|=\\)\\s*'\\)\\@<=.\\{-}\\('\\)\\@=", pos )
        elseif match( line, '^\w\+\s*\(+=\|=\)\s*"' ) != -1
            let val = matchstr( line, '\(\(+=\|=\)\s*"\)\@<=.\{-}\("\)\@=', pos )
        else
            let val = matchstr( line, '\(\(+=\|=\)\s*\)\@<=\S\+', pos )
        endif

        " DEBUG:
        " echomsg var . "=" . val

        if var != ""
            if !exists( 's:vimentry_'.var )
                silent call add( s:varnames, 's:vimentry_'.var )
            endif

            " list variable
            " sytanx:
            " list = val1,val2,
            " list += val1
            " list += val1,val2
            if stridx ( line, '+=') != -1 || stridx ( val, ',' ) != -1
                if !exists( 's:vimentry_'.var ) " if we don't define this list variable, define it first
                    let s:vimentry_{var} = []
                endif


                let vallist = split( val, ',' )
                for v in vallist
                    if v != ""
                        silent call add ( s:vimentry_{var}, v )
                    endif
                endfor

            " string variable
            else
                let s:vimentry_{var} = val
            endif
        endif
    endfor

    " DEBUG:
    " for varname in s:varnames
    "     echomsg varname . " = " . string({varname})
    " endfor
endfunction

" vimentry#on {{{2
let s:event_listeners = {
            \ 'reset': [],
            \ 'changed': [],
            \ 'project_type_changed': [],
            \ }

function vimentry#on( event, funcref )
    if !has_key( s:event_listeners, a:event )
        call ex#warning( "Cant find event " . a:event )
        return
    endif

    if type(a:funcref) != 2
        call ex#warning( "the second argument must be a function ref" )
    endif

    silent call add ( s:event_listeners[a:event], a:funcref )
endfunction

" vimentry#apply_project_type {{{2
function vimentry#apply_project_type()
    " invoke project_type_changed event
    " NOTE: function ref variable must start with captial character
    let listeners = s:event_listeners['project_type_changed']
    for Funcref in listeners
        call Funcref()
    endfor
endfunction

" vimentry#reset {{{2
function vimentry#reset()
    " invoke reset event
    " NOTE: function ref variable must start with captial character
    let listeners = s:event_listeners['reset']
    for Funcref in listeners
        call Funcref()
    endfor
endfunction

" vimentry#apply {{{2
let s:is_first_time = 1
function vimentry#apply()
    " check if we have version
    if vimentry#check('version', '')
        call ex#error('Invalid vimentry file, no version provide.')
        return
    endif

    " if the version is different, write the vimentry file with template and re-parse it
    if !vimentry#check('version', s:version)
        call vimentry#write_default_template()
        call vimentry#parse()
    endif

    " invoke changed event
    " NOTE: function ref variable must start with captial character
    let listeners = s:event_listeners['changed']
    for Funcref in listeners
        call Funcref()
    endfor

    let s:is_first_time = 0
endfunction

" vimentry#is_first_time {{{2
function vimentry#is_first_time()
    return s:is_first_time
endfunction

"}}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
