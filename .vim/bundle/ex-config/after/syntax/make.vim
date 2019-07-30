silent exec ':syn keyword makeTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

if exists("make_microsoft")
   syn match  makeComment "#.*" contains=@Spell,makeTodo,exCommentLable
elseif !exists("make_no_comments")
   syn region  makeComment	start="#" end="^$" end="[^\\]$" keepend contains=@Spell,makeTodo,exCommentLable
   syn match   makeComment	"#$" contains=@Spell
endif

let b:current_syntax = "make"
