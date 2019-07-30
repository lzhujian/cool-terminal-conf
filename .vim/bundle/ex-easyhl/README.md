# Intro

Easyhl is a plugin for temporary highlight words under cursor.

* Highlight words quickly by different label color.
* Easily replace highlight words.  

## Requirements

- Vim 6.0 or higher.

## Installation

This plugin follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-easyhl'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-easyhl

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-easyhl'

[Download zip file](https://github.com/exvim/ex-easyhl/archive/master.zip):

    cd ~/.vim
    unzip ex-easyhl-master.zip
    copy all of the files into your ~/.vim directory

## Usage

* Highlight words under cursor

    Move your cursor to the word you want to highlight. Press `<Alt-1>` or `<Alt-2>` 
    or `<Alt-3>` or `<Alt-4>`

* Highlith visual selection

    By selecting text, and press `<Alt-1>` or `<Alt-2>` or `<Alt-3>` or `<Alt-4>`, you can
    highlight selected text

* Cancel highlight words

    Presss `<Leader>1` or `<Leader>2` or `<Leader>3` or `<Leader>4`
    You also can cancel highlight all by press `<Leader>0` or `<Atl-0>`

* Replace highlight words

    When you use both highlight Label 1 and 2 for highlighting, you can then press
    `<Leader>sub` to replace Label 1 words as Label 2

Check `:help easyhl` for more details.
