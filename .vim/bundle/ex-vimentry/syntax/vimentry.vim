if version < 600
    syntax clear
elseif exists("b:current_syntax")
    finish
endif

" syntax highlight
syn match vimentrySetting transparent /^\w\+\s*\(+=\|=\)\s*[^'" ]*/ contains=vimentryVar,vimentryVal,vimentryOperator
syn match vimentrySettingD transparent '^\w\+\s*\(+=\|=\)\s*".\{-}"' contains=vimentryVar,vimentryValStrD,vimentryOperator
syn match vimentrySettingS transparent "^\w\+\s*\(+=\|=\)\s*'.\{-}'" contains=vimentryVar,vimentryValStrS,vimentryOperator
syn match vimentryOperator	"\(+=\|=\)" contained
syn match vimentryVar	"^\w\+\(\s*\(+=\|=\)\)\@=" contained
syn match vimentryVal	/\(\(+=\|=\)\s*\)\@<=[^'" ]*/ contained
syn region vimentryValStrD start=+"+ end=+"+ oneline contained
syn region vimentryValStrS start=+'+ end=+'+ oneline contained
syn region vimentryComment start="--" skip="\\$" end="$" keepend contains=vimentryWarning
syn match vimentryError "\S\+" contains=vimentrySetting,vimentrySettingD,vimentrySettingS,vimentryComment
syn match vimentryWarning "WARNING:" contained

hi default link vimentryVar vimVar
hi default link vimentryVal vimCommand
hi default link vimentryValStrD vimCommand
hi default link vimentryValStrS vimCommand
hi default link vimentryOperator Operator
hi default link vimentryComment Comment
hi default link vimentryError ErrorMsg
hi default link vimentryWarning WarningMsg

let b:current_syntax = "vimentry"

" vim:ts=4:sw=4:sts=4
