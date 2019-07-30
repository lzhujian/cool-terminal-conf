- - -
- [Intro](#intro)
- [Requirements](#requirements)
- [Installation](#installation)
  - [Install ex-utility](#install-ex-utility)
  - [Install graphviz](#install-graphviz)
  - [Install ex-hierarchy](#install-ex-hierarchy)
- [Usage](#usage)

For more details, check [exVim's Docs: View Class Hierarchies](http://exvim.github.io/docs/view-class-hierarchies)

- - -

# Intro

ex-hierarchy is a plugin working under exVim. It will generate the class inherit relationship 
data and use graphviz draw the specific class hierarchies.

ex-hierarchy is also a part of [exVim](https://github.com/exvim/main) project.

## Requirements

- Vim 6.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility) 
- [graphviz](http://www.graphviz.org/)

## Installation

### Install ex-utility

ex-hierarchy is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This 
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility to install it first.

### Install graphviz

ex-hierarchy used graphviz to draw the class hierarchies. To install it:

**Mac**

    ## use Homebrew
    brew install graphviz

**Linux**

    ## use pat-get
    apt-get install graphviz

    ## use yum
    yum install graphviz

    ## or compile graphviz from source

**Windows**

download it from [graphviz](http://www.graphviz.org/)

### Install ex-hierarchy

ex-hierarchy follows the standard runtime path structure, and as such it can 
be installed with a variety of plugin managers:
    
To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-hierarchy'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-hierarchy

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-hierarchy'

[Download zip file](https://github.com/exvim/ex-hierarchy/archive/master.zip):

    cd ~/.vim
    unzip ex-hierarchy-master.zip
    copy all of the files into your ~/.vim directory

## Usage

**NOTE:** This plugin currently is highly depends on exVim. You need to run `:Update`
command in exVim before using it.

Enter your project, use `:HV your-class` to generate your class hierarchies.

More details, check `:help exhierarchy`.
