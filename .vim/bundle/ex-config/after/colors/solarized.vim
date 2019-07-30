if &background == "dark"
    " NOTE: keep visual mode words still using its own syntax color
    hi Visual gui=NONE guifg=NONE guibg=#004b56

    " ex
    " =============================

    hi clear exConfirmLine
    hi exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

    hi clear exTargetLine
    hi exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

    " ex-easyhl
    " =============================

    hi clear EX_HL_cursorhl
    hi EX_HL_cursorhl gui=none guibg=darkgray term=none cterm=none ctermbg=darkgray

    hi clear EX_HL_label1
    hi EX_HL_label1 gui=none guifg=#002b36 guibg=lightblue term=none cterm=none ctermbg=lightblue

    hi clear EX_HL_label2
    hi EX_HL_label2 gui=none guifg=#002b36 guibg=lightmagenta term=none cterm=none ctermbg=darkmagenta

    hi clear EX_HL_label3
    hi EX_HL_label3 gui=none guifg=#002b36 guibg=darkyellow term=none cterm=none ctermbg=darkyellow

    hi clear EX_HL_label4
    hi EX_HL_label4 gui=none guifg=#002b36 guibg=lightgreen term=none cterm=none ctermbg=darkgreen

    " ex-showmarks highlight
    " =============================

    " For marks a-z
    hi clear ShowMarksHLl
    hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=#eee8d5

    " For marks A-Z
    hi clear ShowMarksHLu
    hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

    " ex-taglist highlight
    " =============================

    hi clear MyTagListFileName
    hi link MyTagListFileName Directory

    " ex-project highlight
    " =============================

    hi link ex_pj_tree_line NONE
    hi ex_pj_tree_line term=italic ctermfg=11 gui=none guifg=#586e75

    " minibufexpl highlight
    " =============================

    hi MBENormal ctermfg=14 guifg=#586e75 guibg=#073642
    hi MBEChanged ctermfg=14 guifg=#dc322f guibg=#073642
    hi MBEVisibleNormal ctermfg=245 ctermbg=235 guifg=#073642 guibg=#586e75
    hi MBEVisibleChanged ctermfg=Black ctermbg=DarkRed guifg=Black guibg=DarkRed
    hi MBEVisibleActiveNormal term=bold cterm=bold ctermfg=245 ctermbg=235 gui=bold guifg=#073642 guibg=#93a1a1
    hi MBEVisibleActiveChanged term=bold cterm=bold ctermfg=Black ctermbg=Red gui=bold guifg=Black guibg=#dc322f

    " better whitespace highlight
    " =============================
    hi clear ExtraWhitespace
    hi link ExtraWhitespace ErrorMsg
else
    " NOTE: keep visual mode words still using its own syntax color
    hi Visual gui=NONE guifg=NONE guibg=#ddd6c3

    " ex
    " =============================

    hi clear exConfirmLine
    hi exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

    hi clear exTargetLine
    hi exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow

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

    " ex-showmarks highlight
    " =============================

    " For marks a-z
    hi clear ShowMarksHLl
    hi ShowMarksHLl term=bold cterm=none ctermbg=grey gui=none guibg=grey

    " For marks A-Z
    hi clear ShowMarksHLu
    hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

    " ex-taglist highlight
    " =============================

    hi clear MyTagListFileName
    hi link MyTagListFileName Directory

    " ex-project highlight
    " =============================

    hi link ex_pj_tree_line NONE
    hi ex_pj_tree_line term=italic ctermfg=1 gui=none guifg=#93a1a1

    " minibufexpl highlight
    " =============================

    hi MBENormal ctermfg=14 guifg=#93a1a1 guibg=#eee8d5
    hi MBEChanged ctermfg=14 guifg=#dc322f guibg=#eee8d5
    hi MBEVisibleNormal ctermfg=245 ctermbg=235 guifg=#eee8d5 guibg=#93a1a1
    hi MBEVisibleChanged ctermfg=Black ctermbg=DarkRed guifg=Black guibg=#dc322f
    hi MBEVisibleActiveNormal term=bold cterm=bold ctermfg=245 ctermbg=235 gui=bold guifg=#eee8d5 guibg=#586e75
    hi MBEVisibleActiveChanged term=bold cterm=bold ctermfg=Black ctermbg=Red gui=bold guifg=Black guibg=DarkRed

    " better whitespace highlight
    " =============================
    hi clear ExtraWhitespace
    hi link ExtraWhitespace ErrorMsg
endif

" vim:ts=4:sw=4:sts=4 et fdm=marker:
