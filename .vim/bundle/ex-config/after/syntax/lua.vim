silent exec ':syn keyword luaTodo contained ' . g:ex_todo_keyword
silent exec ':syn keyword exCommentLable contained ' . g:ex_comment_lable_keyword

syn match luaComment "--.*$" contains=@Spell,luaTodo,exCommentLable
if lua_version == 5 && lua_subversion == 0
    syn region  luaComment        matchgroup=luaComment start="--\[\[" end="\]\]" contains=luaTodo,luaInnerComment,@Spell,exCommentLable
elseif lua_version > 5 || (lua_version == 5 && lua_subversion >= 1)
    " Comments in Lua 5.1: --[[ ... ]], [=[ ... ]=], [===[ ... ]===], etc.
    syn region  luaComment        matchgroup=luaComment start="--\[\z(=*\)\[" end="\]\z1\]" contains=luaTodo,@Spell,exCommentLable
endif

let b:current_syntax = "lua"
