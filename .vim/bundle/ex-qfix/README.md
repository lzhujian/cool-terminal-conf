- - -
- [Intro](#intro)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Install ex-utility](#install-ex-utility)
  - [Install ex-qfix](#install-ex-qfix)
- [Usage](#usage)

For more details, check [exVim's Docs: QuickFix Window](http://exvim.github.io/docs/qfix-window)

- - -

# Intro

TODO

ex-qfix is also a part of [exVim](https://github.com/exvim/main) project.

## Requirements

- Vim 6.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility) 

## Installation

### Install ex-utility

ex-qfix is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This 
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility to install it first.

### Install ex-qfix

ex-qfix follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-qfix'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-qfix

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-qfix'

[Download zip file](https://github.com/exvim/ex-qfix/archive/master.zip):

    cd ~/.vim
    unzip ex-qfix-master.zip
    copy all of the files into your ~/.vim directory

## Usage

More details, check [exVim's Docs: QuickFix Window](http://exvim.github.io/docs/qfix-window)
and `:help exqfix` in Vim.

