runtime! after/syntax/c.vim
unlet b:current_syntax

"/////////////////////////////////////////////////////////////////////////////
" syntax defines
"/////////////////////////////////////////////////////////////////////////////

" exSDK extentions
syn keyword cStatement  ex_new ex_new_use ex_new_tag ex_new_tag_use ex_new_nomng ex_new_in ex_new_at ex_stack_malloc
syn keyword cStatement  ex_new_array ex_new_array_use ex_new_array_tag ex_new_array_tag_use ex_new_array_nomng
syn keyword cStatement  ex_delete ex_delete_use ex_delete_nomng ex_delete_in
syn keyword cStatement  ex_safe_delete ex_safe_delete_use ex_safe_delete_nomng ex_safe_delete_in
syn keyword cStatement  ex_delete_array ex_delete_array_use ex_delete_array_nomng
syn keyword cStatement  ex_safe_delete_array ex_safe_delete_array_use ex_safe_delete_array_nomng
syn keyword cStatement  ex_try ex_catch ex_catch_exp ex_throw

" exMacroHighlight Predeined Syntax
" add cpp enable group
syn cluster exEnableContainedGroup add=cppStatement,cppAccess,cppType,cppExceptions,cppOperator,cppCast,cppStorageClass,cppStructure,cppNumber,cppBoolean,cppMinMax

let b:current_syntax = "cpp"

" vim: ts=8
