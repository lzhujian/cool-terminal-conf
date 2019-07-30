- - -
- [Intro](#intro)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Install ex-utility](#install-ex-utility)
  - [Install ex-symbol](#install-ex-symbol)
- [Usage](#usage)

For more details, check [exVim's Docs: Tags and Symbols](http://exvim.github.io/docs/tags-and-symbols)

- - -

# Intro

ex-symbol is a Vim plugin which can list all tag names in the plugin window for 
search and jump.

ex-symbol is also a part of [exVim](https://github.com/exvim/main) project.

## Requirements

- Vim 6.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility) 

## Installation

### Install ex-utility

ex-symbol is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This 
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility to install it first.

### Install ex-symbol

ex-symbol follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-symbol'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-symbol

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-symbol'

[Download zip file](https://github.com/exvim/ex-symbol/archive/master.zip):

    cd ~/.vim
    unzip ex-symbol-master.zip
    copy all of the files into your ~/.vim directory

