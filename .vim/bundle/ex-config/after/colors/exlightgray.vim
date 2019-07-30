exec 'AirlineTheme kolor'

" ex
" =============================

hi clear exConfirmLine
hi exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow

hi clear exTargetLine
hi exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=DarkYellow

" ex-easyhl
" =============================

hi clear EX_HL_cursorhl
hi EX_HL_cursorhl gui=none guibg=White term=none cterm=none ctermbg=white

hi clear EX_HL_label1
hi EX_HL_label1 gui=none guibg=lightcyan term=none cterm=none ctermbg=lightcyan

hi clear EX_HL_label2
hi EX_HL_label2 gui=none guibg=lightmagenta term=none cterm=none ctermbg=lightmagenta

hi clear EX_HL_label3
hi EX_HL_label3 gui=none guibg=lightred term=none cterm=none ctermbg=lightred

hi clear EX_HL_label4
hi EX_HL_label4 gui=none guibg=lightgreen term=none cterm=none ctermbg=lightgreen

" ex-project
" =============================

hi clear ex_pj_tree_line
hi ex_pj_tree_line gui=none guifg=darkgray term=none cterm=none ctermfg=gray

hi clear ex_pj_folder_label
hi ex_pj_folder_label gui=bold guifg=brown term=bold cterm=bold ctermfg=darkred

" ex-gsearch
" =============================

hi clear ex_gs_linenr
hi link ex_gs_linenr LineNr

hi clear ex_gs_header
hi ex_gs_header gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray

hi clear ex_gs_filename
hi link ex_gs_filename Statement

" ex-tags
" =============================

hi clear ex_ts_header
hi ex_ts_header gui=bold guifg=DarkRed guibg=LightGray term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray

hi clear ex_ts_filename
hi link ex_ts_filename Statement

" ex-showmarks highlight
" =============================

" For marks a-z
hi clear ShowMarksHLl
hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=lightblue

" For marks A-Z
hi clear ShowMarksHLu
hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

" ex-taglist highlight
" =============================

" TagListTagName  - Used for tag names
hi clear MyTagListTagName
hi MyTagListTagName term=bold cterm=none ctermfg=Black ctermbg=DarkYellow gui=none guifg=Black guibg=#ffe4b3

" TagListTagScope - Used for tag scope
hi clear MyTagListTagScope
hi MyTagListTagScope term=NONE cterm=NONE ctermfg=Blue gui=NONE guifg=Blue

" TagListTitle    - Used for tag titles
hi clear MyTagListTitle
" hi MyTagListTitle term=bold cterm=bold ctermfg=DarkRed ctermbg=LightGray gui=bold guifg=DarkRed guibg=LightGray
hi MyTagListTitle term=bold cterm=bold ctermfg=DarkRed ctermbg=Gray gui=bold guifg=DarkRed guibg=Gray

" TagListComment  - Used for comments
hi clear MyTagListComment
hi MyTagListComment ctermfg=DarkGreen guifg=DarkGreen

" TagListFileName - Used for filenames
hi clear MyTagListFileName
hi MyTagListFileName term=bold cterm=bold ctermfg=Black ctermbg=LightBlue gui=bold guifg=Black guibg=LightBlue

" minibufexpl highlight
" =============================

hi MBENormal ctermbg=LightGray ctermfg=DarkGray guibg=LightGray guifg=DarkGray
hi MBEChanged ctermbg=Red ctermfg=DarkRed guibg=Red guifg=DarkRed
hi MBEVisibleNormal term=bold cterm=bold ctermbg=Gray ctermfg=Black gui=bold guibg=Gray guifg=Black
hi MBEVisibleChanged term=bold cterm=bold ctermbg=DarkRed ctermfg=Black gui=bold guibg=DarkRed guifg=Black
hi MBEVisibleActiveNormal term=bold cterm=bold ctermbg=Gray ctermfg=Black gui=bold guibg=Gray guifg=Black
hi MBEVisibleActiveChanged term=bold cterm=bold ctermbg=DarkRed ctermfg=Black gui=bold guibg=DarkRed guifg=Black

" better whitespace highlight
" =============================
hi clear ExtraWhitespace
hi link ExtraWhitespace ErrorMsg
