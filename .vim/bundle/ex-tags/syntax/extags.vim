if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight
syntax match ex_ts_help #^".*# contains=ex_ts_help_key
syntax match ex_ts_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_ts_help_comma
syntax match ex_ts_help_comma ':' contained

syntax match ex_ts_header '^[^" ]\+'
syntax match ex_ts_filename '^\S\+\s(.\+)$'
syntax match ex_ts_nr '^        \d\+:'
syntax match ex_ts_normal '^        \S.*$' contains=ex_ts_nr
syntax match ex_ts_error '^Error:.*'


hi default link ex_ts_help Comment
hi default link ex_ts_help_key Label
hi default link ex_ts_help_comma Special

hi default link ex_ts_header SpecialKey
hi default link ex_ts_filename Directory
hi default link ex_ts_nr Special
hi default link ex_ts_normal Normal
hi default link ex_ts_error Error

let b:current_syntax = "extags"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
