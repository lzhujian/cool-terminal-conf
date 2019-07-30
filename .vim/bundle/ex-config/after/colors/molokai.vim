if &background == "dark"
    " NOTE: keep visual mode words still using its own syntax color  
    " hi Visual gui=NONE guifg=NONE guibg=#004b56
    hi Visual               guibg=DarkGrey       gui=bold ctermbg=251  ctermfg=238 cterm=bold 
    " hi Visual      guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none
    " hi Visual term=reverse cterm=reverse guifg=#f6f3e8 guibg=#444444 

    " ex
    " =============================

    hi clear exConfirmLine
    " hi exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
    hi exConfirmLine       guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none

    hi clear exTargetLine
    " hi exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
    hi exTargetLine       guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none

    " ex-easyhl
    " =============================

    hi clear EX_HL_cursorhl
    hi EX_HL_cursorhl gui=none guibg=darkgray term=none cterm=none ctermbg=darkgray

    hi clear EX_HL_label1
    " hi EX_HL_label1 gui=none guibg=lightblue term=none cterm=none ctermbg=lightblue
    hi EX_HL_label1 gui=none guifg=black guibg=lightblue term=none cterm=none ctermbg=lightblue
    
    hi clear EX_HL_label2
    hi EX_HL_label2 gui=none guifg=black guibg=lightmagenta term=none cterm=none ctermbg=darkmagenta

    hi clear EX_HL_label3
    hi EX_HL_label3 gui=none  guifg=black guibg=darkyellow term=none cterm=none ctermbg=darkyellow

    hi clear EX_HL_label4
    hi EX_HL_label4 gui=none guifg=black guibg=darkgreen term=none cterm=none ctermbg=darkgreen

    " ex-showmarks highlight
    " =============================

    " For marks a-z
    " hi clear ShowMarksHLl
    " hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=#eee8d5

    " For marks A-Z
    " hi clear ShowMarksHLu
    " hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

    " ex-taglist highlight
    " =============================

    hi clear MyTagListFileName
    hi link MyTagListFileName Directory

    " ex-project highlight
    " =============================

    hi link ex_pj_tree_line NONE
    hi ex_pj_tree_line term=italic ctermfg=11 gui=none guifg=#586e75
else
    " NOTE: keep visual mode words still using its own syntax color  
    " hi Visual gui=NONE guifg=NONE guibg=#ddd6c3
    hi Visual               guibg=DarkGrey       gui=bold ctermbg=251  ctermfg=238 cterm=bold 
    " hi Visual      guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none
    " hi Visual term=reverse cterm=reverse guifg=#f6f3e8 guibg=#444444 
    " ex
    " =============================

    hi clear exConfirmLine
    " hi exConfirmLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
    hi exConfirmLine       guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none

    hi clear exTargetLine
    " hi exTargetLine gui=none guibg=#ffe4b3 term=none cterm=none ctermbg=darkyellow
    hi exTargetLine       guifg=gray80         guibg=#445599        gui=none ctermfg=252 ctermbg=61 cterm=none

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
    " hi clear ShowMarksHLl
    " hi ShowMarksHLl term=bold cterm=none ctermbg=grey gui=none guibg=grey

    " For marks A-Z
    " hi clear ShowMarksHLu
    " hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred

    " ex-taglist highlight
    " =============================

    hi clear MyTagListFileName
    hi link MyTagListFileName Directory

    " ex-project highlight
    " =============================

    hi link ex_pj_tree_line NONE
    hi ex_pj_tree_line term=italic ctermfg=1 gui=none guifg=#93a1a1
endif

" vim:ts=4:sw=4:sts=4 et fdm=marker:
