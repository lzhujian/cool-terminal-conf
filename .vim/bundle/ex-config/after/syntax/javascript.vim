" NOTE: the original javscript syntax file use 'syn case ignore'.
syn case match

silent exec ':syn keyword jsCommentTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

syntax region  jsLineComment    start=+\/\/+ end=+$+ keepend contains=jsCommentTodo,exCommentLable,@Spell
syntax region  jsLineComment    start=+^\s*\/\/+ skip=+\n\s*\/\/+ end=+$+ keepend contains=jsCommentTodo,exCommentLable,@Spell fold
syntax region  jsComment        start="/\*"  end="\*/" contains=jsCommentTodo,exCommentLable,jsCvsTag,@Spell fold

" finish
let b:current_syntax = "javascript"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
