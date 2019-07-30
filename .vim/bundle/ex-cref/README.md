# Intro

The intention of this project is to provide a C-reference manual that can
be viewed with Vim and accessed from within Vim. 
The C-reference is a reference, it is NOT a tutorial or a guide on how
to write C-programs. It is a quick reference to the functions and syntax 
of the standard C language.

## Requirements

- Vim 6.0 or higher.

## Installation

This plugin follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-cref'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-cref

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-cref'

[Download zip file](https://github.com/exvim/ex-cref/archive/master.zip):

    cd ~/.vim
    unzip ex-cref-master.zip
    copy all of the files into your ~/.vim directory


## Usage

There are several ways to specify a word CRefVim should search for in order
to view help:

- `<Leader>cr` normal mode:  get help for word under cursor.
- `<Leader>cr` visual mode:  get help for visually selected text.

**Note:** by default `<Leader>` is \, e.g. press `\cr` to invoke C-reference

**Note:** The best way to search for an operator (++, --, %, ...) is to visually select it and press <Leader>cr.

To get help do :help crefvimdoc

To show the C-reference manual do :help crefvim

## Changes for exVim

This is a modified version of CRefVim to make it workable with exVim. 

- Disabled `<Leader>cw`
- Disabled `<Leader>cc`

The <Leader>cw, <Leader>cc has conflict map with NERDComment and seldom used.
So I disable these two mappings.
