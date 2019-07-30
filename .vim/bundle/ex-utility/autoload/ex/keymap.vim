function! s:sort_mappings( i1, i2 )
    if a:i1.priority != a:i2.priority
        return a:i1.priority > a:i2.priority ? 1 : -1
    endif

    if a:i1.key !=# a:i2.key
        return a:i1.key ># a:i2.key ? 1 : -1
    endif

    return 0 
endfunction

" ex#keymap#register {{{
" keymap: the dictionary used for store keymappings
" priority: a number to rule the help text order
" key: the key in Vim's key format string
" action: the action function name
" desc: description
function ex#keymap#register( keymap, priority, local, key, action, desc )
    " pre-check
    if type(a:keymap) != type({}) 
        call ex#error( "Wrong a:keymap type, please send a Dictionary" )
        return
    endif

    " get key-mappings
    let a:keymap[a:key] = {
                \ 'priority': a:priority,
                \ 'local': a:local,
                \ 'key': a:key,
                \ 'action': a:action,
                \ 'desc': a:desc,
                \ }

    " immediately map non-local mappings
    if a:local == 0
        silent exec 'nnoremap <unique> '
                    \ . a:key . ' ' 
                    \ . a:action
    endif
endfunction

" ex#keymap#bind {{{
function ex#keymap#bind( keymap )
    " pre-check
    if type(a:keymap) != type({}) 
        call ex#error( "Wrong a:keymap type, please send a Dictionary" )
        return
    endif

    let mappings = values(a:keymap)
    call sort( mappings, function('s:sort_mappings') )

    for m in mappings
        if m.local 
            silent exec 'nnoremap <silent> <buffer> '
                        \ . m.key . ' ' 
                        \ . m.action
        endif
    endfor
endfunction

" ex#keymap#helptext {{{
" return a list of help texts
function ex#keymap#helptext( keymap )
    " pre-check
    if type(a:keymap) != type({}) 
        call ex#error( "Wrong a:keymap type, please send a Dictionary" )
        return []
    endif

    let mappings = values(a:keymap)
    call sort( mappings, function('s:sort_mappings') )

    let text = []
    for m in mappings
        silent call add( text, '" ' . m.key . ': ' . m.desc )
    endfor
    silent call add( text, '' )
    return text
endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
