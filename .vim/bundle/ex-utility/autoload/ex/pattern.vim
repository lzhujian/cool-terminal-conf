" ex#pattern#fitlers {{{2
function ex#pattern#last_words(list)
    let pattern = '\m'
    for word in a:list
        if word == ''
            continue
        endif
        let pattern = pattern . '\<' . word . '\>$\|'
    endfor
    return strpart(pattern, 0, strlen(pattern)-2)
endfunction

" ex#pattern#files{{{2
function ex#pattern#files(list)
    let pattern = '\m'
    for word in a:list
        if word == ''
            continue
        endif
        let word = substitute(word, '\.','\\.',"g")
        let word = substitute(word, '\*','.*', "g")
        let pattern = pattern . '^' . word . '$\|'
    endfor
    return strpart(pattern, 0, strlen(pattern)-2)
endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
