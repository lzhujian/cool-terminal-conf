# Intro

ShowMarks provides a visual representation of the location marks.
Marks are useful for jumping back and forth between interesting points in a buffer, but can be hard to keep track of without any way to see where you have placed them.  ShowMarks hopefully makes life easier by placing a sign in the leftmost column of the buffer.  The sign indicates the label of the mark and its location.
It can be toggled on and off and individual marks can be hidden(effectively removing them).

By default the following keymappings are defined:
- \mt : Toggles ShowMarks on and off.
- \mh : Hides an individual mark.
- \ma : Hides all marks in the current buffer.
- \mm : Places the next available mark.

ShowMarks requires that Vim is compiled with the +signs feature.

## Requirements

- Vim 6.0 or higher.

## Installation

This plugin follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-showmarks'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-showmarks

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-showmarks'

[Download zip file](https://github.com/exvim/ex-showmarks/archive/master.zip):

    cd ~/.vim
    unzip ex-showmarks-master.zip
    copy all of the files into your ~/.vim directory

## What I changed

**Apply the patched come from Easwy's blog**

Easwy in his blog (http://easwy.com/blog/) published a patch for showmarks plugin, in the article [advanced vim skills: advanced move method](http://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method) Since it is all in Chinese, I'll give you an explanation of what he have done. 

The patch will fix a bug that the uppercase marks will showed in every file in the line you define it. After the patch, it only show up in the line in the file last time you define it.

**Add toggle method for mark define**

When you define mark "a", the way you can remove the mark highlight is use `<leader>mh` in the place you define it, or use `<leader>ma` to remove all marks. I think it make people comfortable to remove makrs just by typeing the mark define again in the same place. So I add this method. 

So now when you define mark "a" in place 1, and move around to some where, when you back, you can remove it by typing "ma" again.

**Add unique method for mark define**

You can define multiple marks in same place, and showmakrs plugin even provide you different color when a line have marks more than one. But I don't understand why people want to define two or more makrs in same place, it is wasted, and hard to remember marks. 

So I change the mark define behavior in showmarks plugin, now if you define mark "a" in place1, and then when you define mark "b" in same place, it will occupy the place by taking mark "a" off.  So you will have only one mark in one place.

## Recommended .vimrc settings

Here is my settings of ShowMarks in my vimrc file:

```vim
let g:showmarks_enable = 1
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"

" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 0 
```

## Recommended highlights

**exlightgray**

```vim
" highlights 
" For marks a-z
hi clear ShowMarksHLl
hi ShowMarksHLl term=bold cterm=none ctermbg=LightBlue gui=none guibg=LightBlue
" For marks A-Z
hi clear ShowMarksHLu
hi ShowMarksHLu term=bold cterm=bold ctermbg=LightRed ctermfg=DarkRed gui=bold guibg=LightRed guifg=DarkRed
" For all other marks
hi clear ShowMarksHLo
hi ShowMarksHLo term=bold cterm=bold ctermbg=LightYellow ctermfg=DarkYellow gui=bold guibg=LightYellow guifg=DarkYellow
" For multiple marks on the same line.
hi clear ShowMarksHLm
hi ShowMarksHLm term=bold cterm=none ctermbg=LightBlue gui=none guibg=SlateBlue
```

**solarized**

```vim
if &background == "light"
    " For marks a-z
    hi clear ShowMarksHLl
    hi ShowMarksHLl term=bold cterm=none ctermbg=grey gui=none guibg=grey

    " For marks A-Z
    hi clear ShowMarksHLu
    hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred
else
    " For marks a-z
    hi clear ShowMarksHLl
    hi ShowMarksHLl term=bold cterm=none ctermbg=lightblue gui=none guibg=#eee8d5

    " For marks A-Z
    hi clear ShowMarksHLu
    hi ShowMarksHLu term=bold cterm=bold ctermbg=lightred ctermfg=darkred gui=bold guibg=lightred guifg=darkred
endif
```

## Reference

* [ShowMarks on vim.org](http://www.vim.org/scripts/script.php?script_id=152)
* [ShowMarks on github vim-scripts](https://github.com/vim-scripts/ShowMarks)
* [Easwy's patch](http://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method)

