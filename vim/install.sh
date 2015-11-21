#!/bin/sh
cp .vimrc ~/
mkdir -p ~/.vim/colors/
cp detorte.vim ~/.vim/colors/
mkdir -p ~/.vim/after/syntax/
cp c.vim cpp.vim ~/.vim/after/syntax/

