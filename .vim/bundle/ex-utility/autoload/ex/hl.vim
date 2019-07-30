" ex#hl#clear_confirm {{{
function ex#hl#clear_confirm()
    match none
endfunction

" ex#hl#clear_target {{{
function ex#hl#clear_target()
    2match none
endfunction

" ex#hl#confirm_line {{{
function ex#hl#confirm_line(linenr)
    " clear previous highlight result 
    match none

    " highlight the line pattern
    let pat = '/\%' . a:linenr . 'l.*/'
    silent exe 'match exConfirmLine ' . pat
endfunction

" ex#hl#target_line {{{
function ex#hl#target_line(linenr)
    " clear previous highlight result 
    2match none

    " highlight the line pattern
    let pat = '/\%' . a:linenr . 'l.*/'
    silent exe '2match exTargetLine ' . pat
endfunction

" DISABLE
" " ex#hl#select_line {{{
" function ex#hl#select_line()
"     " Clear previously selected name
"     3match none
"     " Highlight the current line
"     let pat = '/\%' . line('.') . 'l.*/'
"     exe '3match ex_SynSelectLine ' . pat
" endfunction

" vim:ts=4:sw=4:sts=4 et fdm=marker:
