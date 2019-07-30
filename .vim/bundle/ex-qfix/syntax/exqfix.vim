if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight
syntax match ex_qf_help #^".*# contains=ex_qf_help_key
syntax match ex_qf_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_qf_help_comma
syntax match ex_qf_help_comma ':' contained

hi default link ex_qf_help Comment
hi default link ex_qf_help_key Label
hi default link ex_qf_help_comma Special

let b:current_syntax = "exqfix"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
