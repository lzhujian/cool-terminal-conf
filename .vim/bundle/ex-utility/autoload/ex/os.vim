" ex#os#is {{{1
" name: osx, windows, linux
function ex#os#is( name )
    if a:name ==# 'osx'
        return has('macunix')
    elseif a:name ==# 'windows'
        return  (has('win16') || has('win32') || has('win64'))
    elseif a:name ==# 'linux'
        return has('unix') && !has('macunix') && !has('win32unix')
    else
        call ex#warning( 'Invalide name ' . a:name . ", Please use 'osx', 'windows' or 'linux'" )
    endif

    return 0
endfunction

" ex#os#open {{{1
function ex#os#open( path )
    if ex#os#is('osx')
        silent exec '!open ' . a:path
        call ex#hint('open ' . a:path)
    elseif ex#os#is('windows')
        let winpath = ex#path#translate(a:path,'windows')
        silent exec '!explorer ' . winpath
        call ex#hint('explorer ' . winpath)
    else
        call ex#warning( 'File borwser not support in Linux' )
    endif
endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
