#!/bin/sh
echo 'Coping .vimrc'
cp .vimrc ~/.vimrc

echo 'Coping detorte colorscheme'
mkdir ~/.vim/colors
cp -r detorte/colors ~/.vim/colors

echo 'Coping plug.vim'
mkdir ~/.vim/autoload
cp -f plug.vim ~/.vim/autoload/plug.vim

# Add support for markdown in Tagbar plugin
echo 'Coping markdown2ctags.py'
cp markdown2ctags.py ~/.vim/
