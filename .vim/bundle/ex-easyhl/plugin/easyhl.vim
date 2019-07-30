
" variables {{{1
if !exists('g:ex_easyhl_auto_cursorhl')
    let g:ex_easyhl_auto_cursorhl = 0
endif

let s:hl_reg_map = ["","q","w","e","r"]
" }}}

" functions {{{1

" s:cursor_hl {{{2
function! s:cursor_hl()
    " check if cursor is stay in a character
    " NOTE: <cword> will get possible cword regardless cursor position.  
    if strpart( getline('.'), col('.')-1, 1 ) !~ '[a-zA-Z]'
        return
    endif

    if !exists('w:ex_easyhl_cursorhl_match_id')
        let w:ex_easyhl_cursorhl_match_id = 0
    endif
    if !exists('w:ex_easyhl_cursorhl_text')
        let w:ex_easyhl_cursorhl_text = ""
    endif

    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    if hl_pattern !=# w:ex_easyhl_cursorhl_text
        let w:ex_easyhl_cursorhl_match_id = matchadd( 'EX_HL_cursorhl', hl_pattern, 0 )
        let w:ex_easyhl_cursorhl_text = hl_pattern
    endif
endfunction

" s:rm_cursor_hl {{{2
function! s:rm_cursor_hl ()
    if !exists('w:ex_easyhl_cursorhl_match_id')
        let w:ex_easyhl_cursorhl_match_id = 0
    endif
    if !exists('w:ex_easyhl_cursorhl_text')
        let w:ex_easyhl_cursorhl_text = ""
    endif

    let hl_word = expand('<cword>')
    let hl_pattern = '\<\C'.hl_word.'\>'
    if w:ex_easyhl_cursorhl_text != '' && ( hl_pattern !=# w:ex_easyhl_cursorhl_text || strpart( getline('.'), col('.')-1, 1 ) !~ '[a-zA-Z]' )
        silent call matchdelete(w:ex_easyhl_cursorhl_match_id)
        let w:ex_easyhl_cursorhl_match_id = 0
        let w:ex_easyhl_cursorhl_text = ''
    endif
endfunction

" s:init_hl_vars {{{2
function! s:init_hl_vars()
    if !exists('w:ex_hl_match_ids')
        let w:ex_hl_match_ids = [0,0,0,0,0]
    endif
    if !exists('w:ex_hl_text')
        let w:ex_hl_text = ["","","","",""]
    endif
endfunction

" s:reset_hl_vars {{{2
function! s:reset_hl_vars(match_nr) " <<<
    if w:ex_hl_match_ids[a:match_nr] != 0
        silent call matchdelete(w:ex_hl_match_ids[a:match_nr])
        let w:ex_hl_match_ids[a:match_nr] = 0
    endif
    let w:ex_hl_text[a:match_nr] = ''
    silent call setreg(s:hl_reg_map[a:match_nr],'') 
endfunction

" s:check_match_nr {{{2
function! s:check_match_nr(match_nr)
    if a:match_nr != 1 && a:match_nr != 2 && a:match_nr != 3 && a:match_nr != 4 
        echohl ErrorMsg
        echomsg 'Error: Invalid argument ' . a:match_nr
        echohl None
        return 0
    endif
    return 1
endfunction

" s:hl_cword {{{2
" Desc: hightlight match_nr
" NOTE: the 1,2,3,4 correspond to reg q,w,e,r

function! s:hl_cword(match_nr)
    " get word under cursor
    call s:hl_text( a:match_nr, '\<\C'.expand('<cword>').'\>' )
endfunction

" s:hl_text {{{2
" Desc: hightlight match_nr with text
" NOTE: the 1,3 will save word to register as \<word\>, the 2,4 will save word to register as word

function! s:hl_text(match_nr, args)
    if s:check_match_nr(a:match_nr) == 0
        return
    endif

    " if no argument comming, cancle hihglight return
    if a:args == ''
        call s:hl_cancel(a:match_nr)
        return
    endif

    "
    call s:init_hl_vars() 

    " if we don't have upper case character, ignore case
    let pattern = a:args
    if match( a:args, '\u' ) == -1
        let pattern = '\c' . pattern
    endif

    " start match
    if pattern ==# w:ex_hl_text[a:match_nr]
        call s:hl_cancel(a:match_nr)
    else
        call s:hl_cancel(a:match_nr)
        let w:ex_hl_match_ids[a:match_nr] = matchadd( 'EX_HL_label'.a:match_nr, pattern, a:match_nr )
        let w:ex_hl_text[a:match_nr] = pattern

        let hl_pattern = a:args
        if a:match_nr == 2 || a:match_nr == 4 " if 2,4, remove \<\C...\>
            if match( hl_pattern, '^\\<\\C.*\\>$') != -1 
                let hl_pattern = strpart( hl_pattern, 4, strlen(hl_pattern) - 6)
            endif
        endif
        silent call setreg(s:hl_reg_map[a:match_nr],hl_pattern) 
    endif
endfunction

" s:hl_range {{{2
" Desc: hightlight match_nr

function! s:hl_range(match_nr) range
    if s:check_match_nr(a:match_nr) == 0
        return
    endif
    call s:init_hl_vars() 

    echomsg 'a:firstline = ' .  a:firstline . ' a:lastline = ' . a:lastline

    " if in the same line
    let pat = '//'
    if a:firstline == a:lastline
        let sl = a:firstline-1
        let sc = col("'<")-1
        let el = a:lastline+1
        let ec = col("'>")+1
        if ec == col("$")+1
            let pat = '\%>'.sl.'l'.'\%>'.sc.'v'.'\%<'.el.'l'.'\%<'.ec.'v'
        else
            " get visual selection text
            try
                let a_save = @a
                silent normal! gv"ay
                let pat = @a
            finally
                let @a = a_save
            endtry
        end
    else
        let sl = a:firstline-1
        let el = a:lastline+1
        let pat = '\%>'.sl.'l'.'\%<'.el.'l'
    endif
    call s:hl_text( a:match_nr, pat )
endfunction

" s:cancle_hl {{{2
" Desc: Cancle highlight

function! s:hl_cancel(match_nr)
    call s:init_hl_vars() 
    if a:match_nr == 0
        call s:reset_hl_vars(1)
        call s:reset_hl_vars(2)
        call s:reset_hl_vars(3)
        call s:reset_hl_vars(4)
    else
        if s:check_match_nr(a:match_nr) == 0
            return
        endif
        call s:reset_hl_vars(a:match_nr)
    endif
endfunction

" }}}1

" syntax highlight {{{1 
hi default EX_HL_cursorhl gui=none guibg=white term=none cterm=none ctermbg=white 
hi default EX_HL_label1 gui=none guibg=lightcyan term=none cterm=none ctermbg=lightcyan
hi default EX_HL_label2 gui=none guibg=lightmagenta term=none cterm=none ctermbg=lightmagenta
hi default EX_HL_label3 gui=none guibg=lightred term=none cterm=none ctermbg=lightred
hi default EX_HL_label4 gui=none guibg=lightgreen term=none cterm=none ctermbg=lightgreen
" }}}1

" autocmd {{{1
if g:ex_easyhl_auto_cursorhl
    augroup ex_easyhl
        au!
        au CursorHold * :call <SID>cursor_hl()
        au CursorMoved * :call <SID>rm_cursor_hl()
    augroup END
endif
" }}}1

" commands {{{1
command! -n=1 EasyhlWord call <SID>hl_cword('<args>')
command! -n=1 EasyhlCancel call <SID>hl_cancel('<args>')
command! -n=1 -range EasyhlRange <line1>,<line2>call <SID>hl_range('<args>')

command! -narg=? HL1 call <SID>hl_text(1, '<args>')
command! -narg=? HL2 call <SID>hl_text(2, '<args>')
command! -narg=? HL3 call <SID>hl_text(3, '<args>')
command! -narg=? HL4 call <SID>hl_text(4, '<args>')
" }}}1

" default mappings {{{1
if !exists("g:easyhl_no_mappings") || !g:easyhl_no_mappings
    if has("gui_running") " gui mode
        " NOTE: though Vim help saids <A-> or <M-> represent as Alt key,
        "       but it doesn't works in Mac. Instead, you need to type the 
        "       character directly when writing the mappings with Alt key.
        if has ("mac")
            nnoremap <unique> <silent> ¡ :EasyhlWord 1<CR>
            nnoremap <unique> <silent> ™ :EasyhlWord 2<CR>
            nnoremap <unique> <silent> £ :EasyhlWord 3<CR>
            nnoremap <unique> <silent> ¢ :EasyhlWord 4<CR>

            vnoremap <unique> <silent> ¡ :EasyhlRange 1<CR>
            vnoremap <unique> <silent> ™ :EasyhlRange 2<CR>
            vnoremap <unique> <silent> £ :EasyhlRange 3<CR>
            vnoremap <unique> <silent> ¢ :EasyhlRange 4<CR>

            nnoremap <unique> <silent> º :EasyhlCancel 0<CR>
        else
            nnoremap <unique> <silent> <M-1> :EasyhlWord 1<CR>
            nnoremap <unique> <silent> <M-2> :EasyhlWord 2<CR>
            nnoremap <unique> <silent> <M-3> :EasyhlWord 3<CR>
            nnoremap <unique> <silent> <M-4> :EasyhlWord 4<CR>

            vnoremap <unique> <silent> <M-1> :EasyhlRange 1<CR>
            vnoremap <unique> <silent> <M-2> :EasyhlRange 2<CR>
            vnoremap <unique> <silent> <M-3> :EasyhlRange 3<CR>
            vnoremap <unique> <silent> <M-4> :EasyhlRange 4<CR>

            nnoremap <unique> <silent> <M-0> :EasyhlCancel 0<CR>
        endif
    else " terminal mode
        nnoremap <unique> <silent> <leader>h1 :EasyhlWord 1<CR>
        nnoremap <unique> <silent> <leader>h2 :EasyhlWord 2<CR>
        nnoremap <unique> <silent> <leader>h3 :EasyhlWord 3<CR>
        nnoremap <unique> <silent> <leader>h4 :EasyhlWord 4<CR>

        vnoremap <unique> <silent> <leader>h1 :EasyhlRange 1<CR>
        vnoremap <unique> <silent> <leader>h2 :EasyhlRange 2<CR>
        vnoremap <unique> <silent> <leader>h3 :EasyhlRange 3<CR>
        vnoremap <unique> <silent> <leader>h4 :EasyhlRange 4<CR>

        nnoremap <unique> <silent> <leader>h0 :EasyhlCancel 0<CR>
    endif

    nnoremap <unique> <silent> <Leader>0 :EasyhlCancel 0<CR>
    nnoremap <unique> <silent> <Leader>1 :EasyhlCancel 1<CR>
    nnoremap <unique> <silent> <Leader>2 :EasyhlCancel 2<CR>
    nnoremap <unique> <silent> <Leader>3 :EasyhlCancel 3<CR>
    nnoremap <unique> <silent> <Leader>4 :EasyhlCancel 4<CR>

    nnoremap <unique> <silent><leader>sub :%s/<c-r>q/<c-r>w/g<CR><c-o>
    vnoremap <unique> <silent><leader>sub  :s/<c-r>q/<c-r>w/g<CR><c-o>
endif
" }}}1

" vim:ts=4:sw=4:sts=4 et fdm=marker:
