# Intro

This is a mirror of http://www.vim.org/scripts/script.php?script_id=273

The "Tag List" plugin is a source code browser plugin for Vim and
provides an overview of the structure of source code files and allows
you to efficiently browse through source code files for different
programming languages.  You can visit the taglist plugin 
[home page](http://vim-taglist.sourceforge.net) for more information.

You can subscribe to the taglist mailing list to post your questions
or suggestions for improvement or to report bugs. Visit the following
page for subscribing to the [mailing list](http://groups.yahoo.com/group/taglist/)

For more information about using this plugin, after installing the
taglist plugin, use the `:help taglist` command.

## Requirements

- Vim 6.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility) 

## Installation

ex-taglist is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This 
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility to install it first.

ex-taglist follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-taglist'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-taglist

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-taglist'

[Download zip file](https://github.com/exvim/ex-taglist/archive/master.zip):

    cd ~/.vim
    unzip ex-taglist-master.zip
    copy all of the files into your ~/.vim directory

## What I changed

**Add target line highlight**

I add highlight for the target line to help user preview of the context clearly.

**Use ex-utility's method for manipulate windows**

Use `ex#windows#...` funcitons in ex-utility for manipulating Vim windows.
