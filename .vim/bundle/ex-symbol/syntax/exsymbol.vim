if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight

syntax match ex_sy_help #^".*# contains=ex_sy_help_key
syntax match ex_sy_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_sy_help_comma
syntax match ex_sy_help_comma ':' contained


hi link ex_sy_help Comment
hi link ex_sy_help_key Label
hi link ex_sy_help_comma Special

let b:current_syntax = "exsymbol"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
