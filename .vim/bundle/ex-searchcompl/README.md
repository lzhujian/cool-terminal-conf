# Intro

Complete vim searches /,? by `<TAB>`

* Highlight words quickly by different label color.
* Easily replace highlight words.  

## Requirements

- Vim 6.0 or higher.

## Installation

This plugin follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-searchcompl'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-searchcompl

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-searchcompl'

[Download zip file](https://github.com/exvim/ex-searchcompl/archive/master.zip):

    cd ~/.vim
    unzip ex-searchcompl-master.zip
    copy all of the files into your ~/.vim directory

## Usage

When using / or ? search text on vim, you can type part of the words, and press `<TAB>`, 
ex-searchcompl will complete the search text under the cursor.
