# Intro

Allows you to create an after/colors/ script for customizing any colorscheme.
This is a bug fixes version for original vim-script AfterColors at
http://www.vim.org/scripts/script.php?script_id=1641

**EXAMPLE**

If you like the 'desert' colorscheme, but you really want comments to be red and functions to be blue, previously you would copy the entire colorscheme into your home directory and customize it.  With this plugin installed, you can create a small script to change just the parts you want for that colorscheme, exactly how you would for an ftplugin or syntax script:

For unix systems you would create:

    # ~/.vim/after/colors/desert.vim:
    highlight Comment guifg=Red ctermfg=Red
    highlight Function guifg=Blue ctermfg=Blue

On windows you would create:

    # C:\Documents and Settings\Peter\vimfiles\after\colors\desert.vim:
    highlight Comment guifg=Red ctermfg=Red
    highlight Function guifg=Blue ctermfg=Blue


## Requirements

- Vim 7.0 or higher.

**VERSION 6 WARNING**

If your Vim is older than version 7, then the after/colors scripts will only be loaded
once when Vim starts.  This will not be a problem if you choose your colorscheme in your
.vimrc file, but if you change your colorscheme after vim has loaded then your after/colors
scripts will be ignored.  This is not an issue in Vim 7.

## Installation

This plugin follows the standard runtime path structure, and as such it can
be installed with a variety of plugin managers:

To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-aftercolors'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-aftercolors

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-aftercolors'

[Download zip file](https://github.com/exvim/ex-aftercolors/archive/master.zip):

    cd ~/.vim
    unzip ex-aftercolors-master.zip
    copy all of the files into your ~/.vim directory

## Reference

* [AfterColors on vim.org](http://www.vim.org/scripts/script.php?script_id=1641)

