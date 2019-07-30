# Intro

ex-vimentry is the vimentry file parser. When you open the file with suffix
`.exvim`, `.vimentry` or `.vimproject`, ex-vimentry will automatically parse
the content in it, and apply the settings once Vim started.

More details, check `:help vimentry`.

## Requirements

- Vim 7.0 or higher.
- [exvim/ex-utility](https://github.com/exvim/ex-utility)

## Installation

ex-vimentry is written based on [exvim/ex-utility](https://github.com/exvim/ex-utility). This
is the basic library of ex-vim-plugins. Follow the readme file in ex-utility
and install it first.

ex-vimentry follows the standard runtime path structure, and as such it can
be installed with a variety of plugin managers:

To install using [Vundle](https://github.com/gmarik/vundle):

    # add this line to your .vimrc file
    Bundle 'exvim/ex-vimentry'

To install using [Pathogen](https://github.com/tpope/vim-pathogen):

    cd ~/.vim/bundle
    git clone https://github.com/exvim/ex-vimentry

To install using [NeoBundle](https://github.com/Shougo/neobundle.vim):

    # add this line to your .vimrc file
    NeoBundle 'exvim/ex-vimentry'

[Download zip file](https://github.com/exvim/ex-vimentry/archive/master.zip):

    cd ~/.vim
    unzip ex-vimentry-master.zip
    copy all of the files into your ~/.vim directory

## Syntax

vimentry file allow three type of values:

 - option
 - string
 - array

**Option**

```
name = option_value
```

An option value will become string in vimscript, option doesn't allow white-space in it.

**String**

```
name = 'A string value'
```

A string is almost same as option value, except that it allow white-space in it.

**Array**

```
name = opt1,opt2,opt3
name += opt4
name += opt5,opt6
```

All of three lines above is operating the same array. Array element is separated by `,`.
You can use `+=` to continue operate an existed array.

**NOTE:** If you only have one item for an array, you must use `+=` define it, otherwise
the value will become an option or a string. For example:

```
name += opt1
```

## Add your event listeners

You can add event listeners after vimentry file parsed. To do this, you need to add register
scripts in your `.vimrc` file. ex-vimentry provide `vimentry#on( event, funcref )` function
to help you do this.

There are three different events you can listen to: reset, changed and project\_type\_changed.

 - reset: Before vimentry file apply changed settings.
 - changed: When vimentry file changed, and saved by user.
 - project\_type\_changed: After project\_type changed.

**NOTE:**

## Get vimentry settings.

In last section I show you the way to hook functions for vimentry events. ex-vimentry also
provide another function for get values you defined in vimentry file.

**vimentry#get( name, ... )**

Get value by {name}. You can provide default value in the second parameter, in case of the value
doesn't exists.

**vimentry#check( name, val )**

Check if the {name} of the value you defined is same as the {val}

## Example

Here is a simple example to show you how to use vimentry file settings:

```
function my_func ()
    let project_name = vimentry#get('project_name')
    if project_name == ''
        call ex#error("Can't find vimentry setting 'project_name'.")
        return
    endif
endfunction

vimentry#on( 'changed', function('my_func') )
```
