" NOTE: ftplugin script only execute one time when you open the file

" functions {{{1

" s:init_buffer {{{2
function! s:init_buffer()
    " do not show it in buffer list
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nowrap
endfunction

" s:init_vimentry {{{2
function! s:init_vimentry()
    let filename = expand('%')

    " reset last applys
    call vimentry#reset()

    " if the file is empty, we creat a template for it
    if findfile( fnamemodify(filename,':p'), '.;' ) == "" || empty( readfile(filename) )
        call vimentry#clear_vars()
        call vimentry#write_default_template()
    endif
    call vimentry#parse()

    " apply vimentry settings
    call vimentry#apply()
endfunction
"}}}1

" autocmd {{{1
augroup ex_vimentry_buffer
    au! BufEnter <buffer> call <SID>init_buffer()
    au! BufWritePost <buffer> call <SID>init_vimentry()
    au! VimEnter <buffer> call <SID>init_vimentry()
augroup END
"}}}1

" key mappings {{{1
nnoremap <silent> <buffer> <F5> :call vimentry#apply_project_type()<CR>
"}}}1

" NOTE:
" there are three places can trigger init_vimentry() function
" 1: run vimentry file through Vim command in shell. For example: vim foobar.exvim
" exVim make sure init_vimentry() call after VimEnter.
"
" 2: edit a new (new here means new file or exists file but not loaded into
" current Vim buffer ) vimentry file in current open Vim.  this will trigger
" the script below, and since we already enter vim, the init_vimentry()
" will be invoke after VimEnter.
"
" 3: save a opened vimentry file
" this also make sure init_vimentry() invoked after VimEnter.

if exists('g:ex_vim_entered') && g:ex_vim_entered == 1
    call s:init_vimentry()
endif

" vim:ts=4:sw=4:sts=4 et fdm=marker:
