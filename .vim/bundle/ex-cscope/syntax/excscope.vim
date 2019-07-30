if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight
" syntax match ex_cs_help #^".*# contains=ex_cs_help_key
" syntax match ex_cs_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_cs_help_comma
" syntax match ex_cs_help_comma ':' contained

" syntax match ex_cs_header '^[^" ]\+'
" syntax match ex_cs_filename '^\S\+\s(.\+)$'
" syntax match ex_cs_nr '^        \d\+:'
" syntax match ex_cs_normal '^        \S.*$' contains=ex_cs_nr
" syntax match ex_cs_error '^Error:.*'


syntax region ex_cs_search_pattern start="^----------" end="----------"

" syntax for pattern [qf_nr] preview <<line>> | context
syntax region ex_cs_dummy start='^ \[\d\+\]\s' end='<\d\+>' oneline keepend contains=ex_cs_qf_number,ex_cs_linenr
syntax match ex_cs_qf_number '^ \[\d\+\]' contained
syntax match ex_cs_linenr '<\d\+>' contained

" syntax for pattern [qf_nr] file_name:line: <<fn>> context
syntax match ex_cs_linenr2 '\d\+:' contained
syntax region ex_cs_file_name start="^[^:]*" end=":" keepend oneline contained
syntax region ex_cs_file_name2 start="^ \[\d\+\]\s[^:]*" end=":" keepend oneline contained contains=ex_cs_qf_number
syntax match ex_cs_def_type '<<\S\+>>' contained
syntax match ex_cs_dummy '^\S\+:\d\+:\s<<\S\+>>' contains=ex_cs_linenr2,ex_cs_file_name,ex_cs_def_type
syntax match ex_cs_dummy '^ \[\d\+\]\s\S\+:\d\+:\(\s<<\S\+>>\)*' contains=ex_cs_qf_number,ex_cs_linenr2,ex_cs_file_name2,ex_cs_def_type


hi default link ex_cs_file_name Statement
hi default link ex_cs_linenr LineNr

hi default ex_cs_search_pattern gui=bold guifg=Blue guibg=LightGray term=bold cterm=bold ctermfg=Blue ctermbg=LightGray


hi default ex_cs_qf_number gui=none guifg=Red term=none cterm=none ctermfg=Red

"
hi link ex_cs_file_name2 ex_cs_file_name
hi link ex_cs_linenr2 ex_cs_linenr
hi link ex_cs_def_type Special


syntax match ex_cs_help #^".*# contains=ex_cs_help_key
syntax match ex_cs_help_key '^" \S\+:'hs=s+2,he=e-1 contained contains=ex_cs_help_comma
syntax match ex_cs_help_comma ':' contained

syntax region ex_cs_header start="^----------" end="----------"
syntax region ex_cs_filename start="^[^"][^:]*" end=":" oneline
syntax match ex_cs_linenr '\d\+:'


hi default link ex_cs_help Comment
hi default link ex_cs_help_key Label
hi default link ex_cs_help_comma Special

hi default link ex_cs_header SpecialKey
hi default link ex_cs_filename Directory
hi default link ex_cs_nr Special
hi default link ex_cs_normal Normal
hi default link ex_cs_error Error

let b:current_syntax = "excscope"

" vim:ts=4:sw=4:sts=4 et fdm=marker:
