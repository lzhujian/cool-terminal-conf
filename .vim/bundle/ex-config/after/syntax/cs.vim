silent exec ':syn keyword csTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

syn region csComment start="/\*"  end="\*/" contains=@csCommentHook,csTodo,@Spell,exCommentLable
syn match csComment "//.*$" contains=@csCommentHook,csTodo,@Spell,exCommentLable

let b:current_syntax = "cs"
